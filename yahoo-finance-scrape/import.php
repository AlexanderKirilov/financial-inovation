<?php

$appKeys = [
    '32269138b0msh95d72bacd3c517ap1546aajsna3d7b3922461',
    '369f608462msh8c5e703c702d572p14b2d6jsna8f45ba3e7a9',
];

try {
    // Connect to the SQLite database using PDO
    $pdo = new PDO('sqlite:backup/mydatabase.sqlite');

    // Set error mode to exceptions
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}

try {
    // Create Stocks table
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS Stocks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL UNIQUE,
            longName TEXT,
            beta3year REAL,
            fundFamily TEXT,
            yield REAL,
            threeYearAverageReturn REAL,
            ytdReturn REAL,
            fiveYearAverageReturn REAL,
            cashPosition REAL,
            stockPosition REAL,
            bondPosition REAL,
            otherPosition REAL,
            previousMarketClose REAL,
            currency TEXT,
            riskStatisticsCat TEXT,
            longSummary TEXT
        )
    ");

    // Create SectorWeightings table
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS SectorWeightings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stock_id INTEGER,
            name TEXT NOT NULL,
            percent REAL NOT NULL
        )
    ");

    // Create Holdings table
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS Holdings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stock_id INTEGER,
            name VARCHAR(255) NOT NULL,
            symbol VARCHAR(255) NOT NULL,
            percent REAL NOT NULL
        )
    ");

    $pdo->exec("
        CREATE UNIQUE INDEX IF NOT EXISTS idx_stock_id_symbol ON Holdings(stock_id, symbol);
    ");

    $pdo->exec("
        CREATE TABLE IF NOT EXISTS RiskStatistics (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stock_id INTEGER,
            year INTEGER NOT NULL,
            meanAnnualReturn REAL NOT NULL,
            standardDeviation REAL NOT NULL
        )
    ");
    $pdo->exec("
        CREATE UNIQUE INDEX IF NOT EXISTS idx_stock_id_year ON RiskStatistics(stock_id, year);
    ");

    $pdo->exec("
        CREATE TABLE IF NOT EXISTS AnnualTotalReturns (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stock_id INTEGER,
            year INTEGER NOT NULL,
            return REAL NOT NULL
        )
    ");
    $pdo->exec("
        CREATE UNIQUE INDEX IF NOT EXISTS idx_stock_id_year ON AnnualTotalReturns(stock_id, year);
    ");
    // Prepare an INSERT statement for RiskStatistics
    $stmtRiskStatistics = $pdo->prepare("
        INSERT INTO RiskStatistics (stock_id, year, meanAnnualReturn, standardDeviation)
        VALUES (:stock_id, :year, :meanAnnualReturn, :standardDeviation)
    ");

    // Prepare an INSERT statement
    $stmtStocks = $pdo->prepare("
        INSERT INTO Stocks (symbol, longName, beta3year, fundFamily, yield, threeYearAverageReturn, ytdReturn, fiveYearAverageReturn, cashPosition, stockPosition, bondPosition, otherPosition, previousMarketClose, currency, riskStatisticsCat, longSummary) 
        VALUES (:symbol, :longName, :beta3year, :fundFamily, :yield, :threeYearAverageReturn, :ytdReturn, :fiveYearAverageReturn, :cashPosition, :stockPosition, :bondPosition, :otherPosition, :previousMarketClose, :currency, :riskStatisticsCat, :longSummary)
    ");

    $stmtAnnual = $pdo->prepare("
        INSERT INTO AnnualTotalReturns (stock_id, year, return)
        VALUES (:stock_id, :year, :return)
    ");

    $stmtHoldings = $pdo->prepare("
        INSERT INTO Holdings (stock_id, name, symbol, percent)
        VALUES (:stock_id, :name, :symbol, :percent)
    ");

    $stmtSectorWeights = $pdo->prepare("
        INSERT INTO SectorWeightings (stock_id, name, percent)
        VALUES (:stock_id, :name, :percent)
    ");

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}

$filename = "ETF_list_truncated.csv";
$handle = fopen($filename, 'r');

// Skip the header line (assuming there's a header)
$header = fgetcsv($handle);

$curl = curl_init();
curl_setopt_array($curl, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => "",
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_TIMEOUT => 30,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => "GET",
    CURLOPT_HTTPHEADER => [
        "X-RapidAPI-Host: apidojo-yahoo-finance-v1.p.rapidapi.com",
        "X-RapidAPI-Key: $appKeys[0]"
    ],
]);

while (($line = fgetcsv($handle)) !== FALSE) {
    processLine($line, $curl);
}

fclose($handle);
curl_close($curl);

function processLine($line, $curl, $isSecondEntry = false) {
    $symbol = $line[0];
    echo "PARSING {$symbol}" . PHP_EOL;

    curl_setopt($curl, CURLOPT_URL, "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-holdings?symbol=$symbol");

    $response = curl_exec($curl);
    $err = curl_error($curl);

    if ($err) {
        echo "cURL Error #:" . $err;
        if ($isSecondEntry) {
            throw new Error("Two consequetive fails while parsing $symbol");
        }
        retry($curl, $line);
        return;
    }

    try {
        $response = json_decode($response, true, 512, JSON_THROW_ON_ERROR);
        if (empty($response)) {
            var_dump(curl_getinfo($curl));
            if ($isSecondEntry) {
                throw new Error("Two consequetive fails while parsing $symbol");
            }
            retry($curl, $line);
        } else {
            parseETF($response);
        }
    } catch (JsonException $e) {
        var_dump(curl_getinfo($curl));
        echo "Error parsing API response: " . $e->getMessage() . PHP_EOL;
        echo "FOR SYMBOL: $symbol" . PHP_EOL;
        throw new Error("JSON PARSE fails while parsing $symbol");
    }
}
function retry($curl, $line) {
    sleep(5);
    #rotateKeys
    global $appKeys;
    [$appKeys[0], $appKeys[1]] = [$appKeys[1], $appKeys[0]];
    curl_setopt($curl, CURLOPT_HTTPHEADER, [
        "X-RapidAPI-Host: apidojo-yahoo-finance-v1.p.rapidapi.com",
        "X-RapidAPI-Key: $appKeys[0]"
    ]);
    echo "Retrying with key $appKeys[0]" . PHP_EOL;

    processLine($line, $curl, true);
}

function parseETF($response) {
    if (empty ($response['symbol'])) {
        echo "Error parsing API response: symbol not found" . PHP_EOL;
        return;
    }
    $symbol = $response['symbol'];
    $longName = $response['price']['longName'] ?? $response['quoteType']['longName'];
    $beta3year = $response['defaultKeyStatistics']['beta3Year']['raw'];
    $fundFamily = $response['defaultKeyStatistics']['fundFamily'];
    $yield = $response['summaryDetail']['yield']['raw'];
    $threeYearAverageReturn = $response['defaultKeyStatistics']['threeYearAverageReturn']['raw'] ?? 0;
    $ytdReturn = $response['defaultKeyStatistics']['ytdReturn']['raw'];
    $fiveYearAverageReturn = $response['defaultKeyStatistics']['fiveYearAverageReturn']['raw'] ?? 0;
    $sectorWeightings = $response['topHoldings']['sectorWeightings'];
    $holdings = $response['topHoldings']['holdings'];
    $cashPosition = $response['topHoldings']['cashPosition']['raw'];
    $stockPosition = $response['topHoldings']['stockPosition']['raw'];
    $bondPosition = $response['topHoldings']['bondPosition']['raw'];
    $otherPosition = $response['topHoldings']['otherPosition']['raw'];
    $previousMarketClose = $response['summaryDetail']['previousClose']['raw'];
    $currency = $response['price']['currency'];
    $riskStatistics = $response['fundPerformance']['riskOverviewStatistics']['riskStatistics'];
    $annualTotalReturns = $response['fundPerformance']['annualTotalReturns']['returns'];
    $longSummary = $response['assetProfile']['longBusinessSummary'];

    $annualTotalReturnsParsed = array_map(function ($annualTotalReturn) {
        if (empty($annualTotalReturn['annualValue']['raw'])) {
            return null;
        }
        return [
            'year' => $annualTotalReturn['year'],
            'return' => $annualTotalReturn['annualValue']['raw'],
        ];
    }, $annualTotalReturns);
    $annualTotalReturnsParsed = array_filter($annualTotalReturnsParsed);

    $riskStatisticsParsed = array_map(fn ($riskStatistic) =>
    [
        'year' => $riskStatistic['year'],
        'meanAnnualReturn' => $riskStatistic['meanAnnualReturn']['raw'],
        'standardDeviation' => $riskStatistic['stdDev']['raw'],
    ],
        $riskStatistics);

    $sectorWeightingsParsed = array_map(function ($sectorWeighting) {
        $key = array_keys($sectorWeighting)[0];
        return [
            'name' => $key,
            'percent' => $sectorWeighting[$key]['raw'],
        ];
    }, $sectorWeightings);

    $holdingsParsed = array_map(function ($holding) {
        return [
            'name' => $holding['holdingName'],
            'symbol' => $holding['symbol'],
            'percent' => $holding['holdingPercent']['raw'],
        ];
    }, $holdings);

    global $pdo;

    try {
        global $stmtStocks;
        // Bind the PHP variables to the placeholders in the SQL statement
        $stmtStocks->bindParam(':symbol', $symbol);
        $stmtStocks->bindParam(':longName', $longName);
        $stmtStocks->bindParam(':beta3year', $beta3year);
        $stmtStocks->bindParam(':fundFamily', $fundFamily);
        $stmtStocks->bindParam(':yield', $yield);
        $stmtStocks->bindParam(':threeYearAverageReturn', $threeYearAverageReturn);
        $stmtStocks->bindParam(':ytdReturn', $ytdReturn);
        $stmtStocks->bindParam(':fiveYearAverageReturn', $fiveYearAverageReturn);
        $stmtStocks->bindParam(':cashPosition', $cashPosition);
        $stmtStocks->bindParam(':stockPosition', $stockPosition);
        $stmtStocks->bindParam(':bondPosition', $bondPosition);
        $stmtStocks->bindParam(':otherPosition', $otherPosition);
        $stmtStocks->bindParam(':previousMarketClose', $previousMarketClose);
        $stmtStocks->bindParam(':currency', $currency);
        $stmtStocks->bindParam(':riskStatisticsCat', $riskStatisticsCat);
        $stmtStocks->bindParam(':longSummary', $longSummary);

        // Execute the statement
        $stmtStocks->execute();

        // Get the last inserted ID (useful for inserting related data in other tables)
        $lastStockId = $pdo->lastInsertId();

    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage() . PHP_EOL;
    }


    try {
        // Prepare an INSERT statement for SectorWeightings
        global $stmtSectorWeights;

        // Bind the stock_id to the last inserted ID from the Stocks table
        $stmtSectorWeights->bindParam(':stock_id', $lastStockId);

        foreach ($sectorWeightingsParsed as $sectorWeighting) {
            $stmtSectorWeights->bindParam(':name', $sectorWeighting['name']);
            $stmtSectorWeights->bindParam(':percent', $sectorWeighting['percent']);
            $stmtSectorWeights->execute();
        }

    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage() . PHP_EOL;
    }

    try {
        global $stmtHoldings;

        // Bind the stock_id to the last inserted ID from the Stocks table
        $stmtHoldings->bindParam(':stock_id', $lastStockId);

        foreach ($holdingsParsed as $holding) {
            $stmtHoldings->bindParam(':name', $holding['name']);
            $stmtHoldings->bindParam(':symbol', $holding['symbol']);
            $stmtHoldings->bindParam(':percent', $holding['percent']);
            $stmtHoldings->execute();
        }
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage() . PHP_EOL;
    }

    try {
        global $stmtRiskStatistics;
        // Bind the stock_id to the last inserted ID from the Stocks table
        $stmtRiskStatistics->bindParam(':stock_id', $lastStockId);

        foreach ($riskStatisticsParsed as $riskStatistic) {
            $stmtRiskStatistics->bindParam(':year', $riskStatistic['year']);
            $stmtRiskStatistics->bindParam(':meanAnnualReturn', $riskStatistic['meanAnnualReturn']);
            $stmtRiskStatistics->bindParam(':standardDeviation', $riskStatistic['standardDeviation']);
            $stmtRiskStatistics->execute();
        }
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage(). PHP_EOL;
    }

    try {
        global $stmtAnnual;

        // Bind the stock_id to the last inserted ID from the Stocks table
        $stmtAnnual->bindParam(':stock_id', $lastStockId);

        foreach ($annualTotalReturnsParsed as $annualTotalReturn) {
            $stmtAnnual->bindParam(':year', $annualTotalReturn['year']);
            $stmtAnnual->bindParam(':return', $annualTotalReturn['return']);
            $stmtAnnual->execute();
        }
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage(). PHP_EOL;
    }
}