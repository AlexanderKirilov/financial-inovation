<?php


try {
    // Connect to the SQLite database using PDO
    $pdo = new PDO("sqlite:backup/mydatabase.sqlite");

    // Set error mode to exceptions
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    die(1);
}
$limit = 1000;

[$_, $stocks] = queryStocks("etf_details.csv");
$stockIds = array_column($stocks, 'id');
unset($_, $stocks);
querySectorWeights($stockIds, "sector_weightings.csv");
queryRiskStatistics($stockIds, "risk_statistics.csv");

function queryStocks(string $name): string|array {
    global $pdo;
    global $limit;

    try {
        $stmt = $pdo->query ("
            SELECT
                id,
                symbol,
                yield,
                ytdReturn,
                threeYearAverageReturn,
                fiveYearAverageReturn,
                cashPosition,
                stockPosition,
                bondPosition,
                otherPosition,
                longSummary
            FROM Stocks
            ORDER BY id
            LIMIT $limit
        ");

        $stocks = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $csvContent = outputCSV($stocks, $name);

        echo "OUTPUT STOCKS:" . PHP_EOL;
        echo $csvContent . PHP_EOL;
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }

    return [$csvContent, $stocks];
}

function querySectorWeights(array $stockIds, string $name) :?string
{
    global $pdo;

    try {
        $stmt = $pdo->query("
            SELECT
                stock_id,
                name,
                percent
            FROM SectorWeightings
            WHERE 
                stock_id IN (" . implode(',', $stockIds) . ")
            ORDER BY id
        ");


        $stocks = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $csvContent = outputCSV($stocks, $name);

        echo "OUTPUT SECTOR WEIGHTINGS:" . PHP_EOL;
        echo $csvContent . PHP_EOL;
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
        return null;
    }

    return $csvContent;
}

function queryHoldings(array $stockIds, string $name): ?string {
    global $pdo;

    try {
        $stmt = $pdo->query("
            SELECT stock_id, name, percent
            FROM Holdings
            WHERE stock_id IN (" . implode(',', $stockIds) . ")
            ORDER BY id
        ");

        $stocks = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $csvContent = outputCSV($stocks, $name);

        echo "OUTPUT HOLDINGS:" . PHP_EOL;
        echo $csvContent . PHP_EOL;
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
        return null;
    }

    return $csvContent;
}

function queryRiskStatistics(array $stockIds, $name): ?string {
    global $pdo;

    try {
        $stmt = $pdo->query("
            SELECT stock_id, meanAnnualReturn, standardDeviation
            FROM RiskStatistics
            WHERE stock_id IN (" . implode(',', $stockIds) . ")
            ORDER BY id
        ");


        $stocks = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $csvContent = outputCSV($stocks, $name);

        echo "OUTPUT RiskStatistics:" . PHP_EOL;
        echo $csvContent . PHP_EOL;
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
        return null;
    }

    return $csvContent;
}

function outputCSV($result, $name): String {
    ob_start();

    $output = fopen("./output/$name", 'w');

    fputcsv($output, array_keys(reset($result)));
    foreach ($result as $stock) {
        fputcsv($output, $stock);
    }
    fclose($output);

    return ob_get_clean();
}
