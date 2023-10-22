import Database from 'better-sqlite3'

const dbPath = './../backup/mydatabase.sqlite';

const db = new Database(dbPath, {
    readonly: true
});

const limit = 3;

const placeholders = ([1,2,3]).map(() => '?').join(',');

const sql = `
    SELECT
        Stocks.id,
        symbol,
        longName,
        yield,
        ytdReturn,
        threeYearAverageReturn,
        fiveYearAverageReturn,
        cashPosition,
        stockPosition,
        bondPosition,
        otherPosition,
        longSummary,
        sw.percent AS mainSectorWeight,
        sw.name AS mainSector,
        CASE
            WHEN fiveYearAverageReturn IS NULL OR fiveYearAverageReturn = 0 
                THEN CASE WHEN threeYearAverageReturn IS NULL OR threeYearAverageReturn = 0
                    THEN ytdReturn
                    ELSE threeYearAverageReturn
                END
                ELSE fiveYearAverageReturn
        END AS performancePercentage
    FROM Stocks
    JOIN RiskStatistics ON Stocks.id = RiskStatistics.stock_id
    JOIN (
        SELECT
            stock_id,
            MAX(percent) AS maxPercent,
            name
        FROM SectorWeightings
        GROUP BY stock_id
    ) AS mw ON Stocks.id = mw.stock_id
    JOIN SectorWeightings AS sw ON Stocks.id = sw.stock_id AND mw.maxPercent = sw.percent
    WHERE symbol IN (${placeholders})
    GROUP BY Stocks.id
    ORDER BY performancePercentage DESC
    LIMIT ${limit}
`;

const queryPoints = `
    SELECT
        meanAnnualReturn,
        standardDeviation,
        year
    FROM RiskStatistics
    WHERE stock_id = ?
        AND (standardDeviation IS NOT NULL OR standardDeviation != 0)
    ORDER BY year DESC
`;

export default function returnMatchingEtfList(symbolsTuple) {
    let symbols = symbolsTuple.map((symbol) => {
        return {
            symbol: symbol[0],
            order: symbol[1]
        }
    });
    const rows = db.prepare(sql).all(...symbols.map((symbol) => symbol.symbol));
    let result = [];
    for (let i = 0; i < rows.length; i++) {
        let tempETF = {};
        tempETF.id = rows[i].id;
        tempETF.symbol = rows[i].symbol;
        tempETF.sector = rows[i].mainSector;
        tempETF.shortSummary = "short summary";
        tempETF.longSummary = rows[i].longSummary;
        tempETF.longName = rows[i].longName;
        tempETF.performancePercentage = rows[i].performancePercentage * 100;

        const rows2 = db.prepare(queryPoints).all(rows[i].id)
        console.log(rows2);

        let points = [100];
        for (let y = 1; y < 30; y++) {
            let row = rows2[0];
            let mean = row.meanAnnualReturn;
            let stddev = row.standardDeviation
            let newNumber = points[y - 1] + getNormallyDistributedRandomNumber(mean , stddev / 6);
            points[y] = Math.round(newNumber);
        }

        console.log(points);
        tempETF.chartPoints = points.map((point, index) => {
            return {
                value: point,
                date: new Date(2022, 2, ++index + 1)
            }
        });

        // tempETF.chartPoints = rows2.map((row, index) => {
        //     let mean = row.meanAnnualReturn * 100;
        //     let stddev = row.standardDeviation
        //     return {
        //         value: getNormallyDistributedRandomNumber(mean, stddev),
        //         date: new Date(2019, 1, ++index)
        //     }
        // })
        result.push(tempETF);
    }

    return result;
}
function randomIntFromInterval(min, max) { // min and max included
    return Math.floor(Math.random() * (max - min + 1) + min)
}
function boxMullerTransform() {
    const u1 = Math.random();
    const u2 = Math.random();

    const z0 = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math.PI * u2);
    const z1 = Math.sqrt(-2.0 * Math.log(u1)) * Math.sin(2.0 * Math.PI * u2);

    return { z0, z1 };
}

function getNormallyDistributedRandomNumber(mean, stddev) {
    const { z0, _ } = boxMullerTransform();

    return z0 * stddev + mean;
}