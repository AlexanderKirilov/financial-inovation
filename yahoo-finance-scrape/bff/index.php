<?php

ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');

$data = json_decode(file_get_contents("php://input"), true);

try {
    // Connect to the SQLite database using PDO
    $pdo = new PDO("sqlite:./../backup/mydatabase.sqlite");

    // Set error mode to exceptions
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    die(1);
}

$limit = 3;

$stmt = $pdo->query("
    SELECT
        Stocks.id,
        symbol,
        yield,
        ytdReturn,
        threeYearAverageReturn,
        fiveYearAverageReturn,
        cashPosition,
        stockPosition,
        bondPosition,
        otherPosition,
        longSummary,
        MAX(SectorWeightings.percent) AS mainSectorWeight,
        SectorWeightings.name AS mainSector
    FROM Stocks
    JOIN SectorWeightings ON Stocks.id = SectorWeightings.stock_id
    GROUP BY Stocks.id, SectorWeightings.name
    LIMIT $limit
");

$data = [
    [
        'id' => 1,
        'symbol' => 'QQQ',
        "sector" => "healthcare", // biggest sector
        'shortSummary' => "Short Summary",
        "longSummary" => "Long Summary",
        "performancePercentage"=> 0.0, // FOR SOME PERIOD
        "chartPoints" => [
            [
                "date" => "2019-01-01T00:00:00.000Z",
                "value" => 100
            ], [
                "date" => "2019-12-01T00:00:00.000Z",
                "value" => 1000
            ]
        ]
    ]
];

array_map(function($row) use (&$data) {
    $data[] = [
        'id' => $row['id'],
        'symbol' => $row['symbol'],
        "sector" => $row['mainSector'], // biggest sector
        'shortSummary' => "Short Summary",
        "longSummary" => $row['longSummary'],
        "performancePercentage"=> 0.0, // FOR SOME PERIOD
        "chartPoints" => [
            [
                "date" => "2019-01-01T00:00:00.000Z",
                "value" => rand(80, 120)
            ], [
                "date" => "2019-12-01T00:00:00.000Z",
                "value" => rand(800, 1200)
            ]
        ]
    ];
}, $stmt->fetchAll(PDO::FETCH_ASSOC));

echo json_encode([
    'status' => 'success',
    'data' => [
        'etfs' => $data
    ],
]);
