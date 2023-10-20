// This code is for v4 of the openai package: npmjs.com/package/openai
import { OpenAI } from "openai";
import dotenv from "dotenv";
import express from 'express';

dotenv.config();
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

const app = express();
const port = 3000;
// app.use(express.json());
// app.listen(port, () => {
//     console.log('listening to port', port)
// });

// app.post("/ask", async (req, res) => {
//     const userQuery = req.body.query;
//     const response = await getQuery(userQuery);
//     res.send(response);
// });

const systemQuery =
    `You are a financial advisor aiming to provide the user with valuable financial advice to choose an ETF according to characteristics which will be given in the query. You will be provided with a .csv formatted text string with information about some ETFs. The columns of the file describe the following: {id, name, risk, sustainability, five-year performance, etc...}.

Suggest the user an ETF from the ones provided assuming he has a conservative risk tolerance.  Return the id and YTD performance, in json format.`;

//based on their indicated risk profile

const userQuery = `

Please provide me with an ETF that has a conservative risk tolerance and a high sustainability rating from the data below.  I would like to see the id and YTD performance of the ETF. The data is in csv format. Each row is a different ETF. The columns are as follows: {id, yield, ytdReturn, threeYearAverageReturn, fiveYearAverageReturn, cashPosition, stockPosition, bondPosition, otherPosition, longSummary}. Each ETF has defined sector weightings in the structure {etf_id,name,persent}. They also have holdings and risk statistics. 



OUTPUT ETF details:
id,yield,ytdReturn,threeYearAverageReturn,fiveYearAverageReturn,cashPosition,stockPosition,bondPosition,otherPosition,longSummary
1,0.024300002,0.043059703,0.0425825,0.042333104,0.0070999996,0.9921,0,0,"The fund generally will invest at least 90% of its assets in the component securities of the underlying index and in investments that have economic characteristics that are substantially identical to the component securities of the underlying index. The underlying index is composed of large- and mid-capitalization developed market equities, excluding the U.S. and Canada that have positive environmental, social and governance characteristics as identified by the index provider while exhibiting risk and return characteristics similar to those of the parent index."
2,0.0085,0.1425921,0.0830035,0.0601401,0.0044,0.9957,0,0,"The fund generally will invest at least 80% of its assets in the component securities of the underlying index and in investments that have economic characteristics that are substantially identical to the component securities of the underlying index. The index is a free float-adjusted market capitalization-weighted index. The index is a broad-based index composed of Irish equities. The fund is non-diversified."
3,0.0188,0.0041436,0.0225492,0.0707599,0.0039,0.9961,0,0,"The fund generally will invest at least 80% of its assets in the component securities of its underlying index and in investments that have economic characteristics that are substantially identical to the component securities of its underlying index. The underlying index is a free float-adjusted market capitalization-weighted index that is designed to measure the performance of the large-, mid- and small-capitalization segments of the equity market in the Netherlands. The fund is non-diversified."
4,0.0148,0.0919413,0.068724,0.1122285,0.0026,0.9974,0,0,"The fund generally will invest at least 90% of its assets in the component securities of the underlying index and may invest up to 10% of its assets in certain futures, options and swap contracts, cash and cash equivalents. It is an optimized index designed to maximize exposure to positive environmental, social and governance characteristics while exhibiting risk and return characteristics similar to the MSCI USA Index."
5,0.026300002,0.123866595,0.0969567,0.0214297,0.0022,0.9978,0,0,"The fund generally will invest at least 80% of its assets in the component securities of its underlying index and in investments that have economic characteristics that are substantially identical to the component securities of its underlying index. The index is a free float-adjusted market capitalization-weighted index that is designed to measure the performance of the large- and mid-capitalization segments of the equity market in Spain. The fund is non-diversified."
6,0.0477,-0.0380534,0.067930296,-0.0078944,0.0034,0.99660003,0,0,"The fund generally will invest at least 80% of its assets in the component securities of the underlying index and in investments that have economic characteristics that are substantially identical to the component securities of the underlying index. The index is a free float-adjusted market capitalization-weighted index that is designed to measure the performance of the large-, mid- and small-capitalization segments of the equity market. in Norway. The fund is non-diversified."
7,0.021,0.0410771,0.0188457,0,0.0070999996,0.9915,0,0,"The index is a free float-adjusted market capitalization-weighted index designed to reflect the equity performance of large- and mid-capitalization developed market companies, excluding the U.S. and Canada, with favorable ESG ratings while applying extensive screens, including removing fossil fuel exposure. The fund generally will invest at least 90% of its assets in the component securities of the index and in investments that have economic characteristics that are substantially identical to the component securities of the index. It is non-diversified."
8,0.033,0.0356169,,0,0.024,0.9757,0,0,"The fund seeks to outperform the price and yield performance of the MSCI World ex USA Index before including Fund expenses, while optimizing for LCETR scores criteria based on proprietary BFA research. The Advisor selects portfolio securities that are components of the index. The index measures the performance of large- and mid-capitalization stocks across global developed market countries, excluding the U.S. It is non-diversified."
9,0.0139999995,-0.0170527,,0,0.0119,0.98480004,0.0034,0,"It invests at least 90% of its assets in the component securities of the index and in investments that have economic characteristics that are substantially identical to the component securities of the index and may invest up to 10% of its assets in certain futures, options and swap contracts, cash and cash equivalents. It is non-diversified."
10,0.0323,0.0900742,0.0702503,0.0568287,0.00029999999,0.98440003,0.0153,0,"The fund employs a sampling strategy, which means that the fund is not required to purchase all of the securities represented in the index. It generally invests substantially all, but at least 80%, of its total assets in the securities comprising the index. The index is a market capitalization weighted index designed to represent the performance of some of the largest companies across components of the 20 EURO STOXX Supersector Indexes. The EURO STOXX Supersector Indexes are subsets of the EURO STOXX Index."

OUTPUT SECTOR WEIGHTINGS:
stock_id,name,percent
1,realestate,0.0238
1,consumer_cyclical,0.1083
1,basic_materials,0.0717
1,consumer_defensive,0.0956
1,technology,0.093
1,communication_services,0.040799998
1,financial_services,0.1892
1,utilities,0.0313
1,industrials,0.1616
1,energy,0.0556
1,healthcare,0.129
2,realestate,0.0107
2,consumer_cyclical,0.3261
2,basic_materials,0.23110001
2,consumer_defensive,0.1319
2,technology,0
2,communication_services,0
2,financial_services,0.0952
2,utilities,0
2,industrials,0.1426
2,energy,0
2,healthcare,0.0624
3,realestate,0.0106
3,consumer_cyclical,0.0294
3,basic_materials,0.05
3,consumer_defensive,0.1552
3,technology,0.3007
3,communication_services,0.1287
3,financial_services,0.1446
3,utilities,0
3,industrials,0.1275
3,energy,0.0177
3,healthcare,0.0356
4,realestate,0.0322
4,consumer_cyclical,0.083000004
4,basic_materials,0.0257
4,consumer_defensive,0.0883
4,technology,0.3123
4,communication_services,0.0574
4,financial_services,0.0958
4,utilities,0.0084
4,industrials,0.118
4,energy,0.045100003
4,healthcare,0.1337
5,realestate,0.0427
5,consumer_cyclical,0.0866
5,basic_materials,0
5,consumer_defensive,0
5,technology,0
5,communication_services,0.047199998
5,financial_services,0.3234
5,utilities,0.2904
5,industrials,0.1397
5,energy,0.049000002
5,healthcare,0.0209
6,realestate,0.0038
6,consumer_cyclical,0.0027
6,basic_materials,0.1033
6,consumer_defensive,0.1387
6,technology,0.032
6,communication_services,0.088599995
6,financial_services,0.1924
6,utilities,0.0043
6,industrials,0.1116
6,energy,0.3205
6,healthcare,0.002
7,realestate,0.0448
7,consumer_cyclical,0.0776
7,basic_materials,0.0757
7,consumer_defensive,0.0349
7,technology,0.1548
7,communication_services,0.060300004
7,financial_services,0.2175
7,utilities,0.0056
7,industrials,0.20709999
7,energy,0
7,healthcare,0.121800005
8,realestate,0.016900001
8,consumer_cyclical,0.102
8,basic_materials,0.0588
8,consumer_defensive,0.0933
8,technology,0.08979999
8,communication_services,0.038599998
8,financial_services,0.2048
8,utilities,0.0345
8,industrials,0.17819999
8,energy,0.060700003
8,healthcare,0.1224
9,realestate,0
9,consumer_cyclical,0.0988
9,basic_materials,0.0734
9,consumer_defensive,0.2036
9,technology,0.16620001
9,communication_services,0
9,financial_services,0
9,utilities,0.1663
9,industrials,0.2917
9,energy,0
9,healthcare,0
10,realestate,0
10,consumer_cyclical,0.1909
10,basic_materials,0.0424
10,consumer_defensive,0.0817
10,technology,0.1497
10,communication_services,0.038900003
10,financial_services,0.1626
10,utilities,0.037
10,industrials,0.1571
10,energy,0.066199996
10,healthcare,0.0736



OUTPUT RiskStatistics:
stock_id,meanAnnualReturn,standardDeviation
1,0.42,18.66
1,0.61,19.3
1,0,0
2,0.66,24.17
2,1.12,24.51
2,0.71,19.82
3,0.75,23.41
3,0.62,25.65
3,0.69,18.86
4,0.96,19.52
4,0.81,18.68
4,1,15.35
5,0.36,23.7
5,1.14,25.36
5,0.27,20.73
6,0.21,27.13
6,0.93,26.39
6,0.29,22.55
7,0,0
7,0.41,19.5
7,0,0
8,0,0
8,0,0
8,0,0
9,0,0
9,0,0
9,0,0
10,0.61,22.78
10,0.9,24.18
10,0.47,19.03
`;

await main();

//TODO: Get query from system



async function getQuery(userQuery) {


    const response = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
            {
                "role": "user",
                "content": userQuery
            },
            {
                "role": "system",
                "content": systemQuery
            }
            // ,{
            //     "role: assistant",
            //     "content: ""
            //     }
        ],
        temperature: 1,
        max_tokens: 256,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0,
    });
    return response.choices[0].message.content;



}


async function main() {
    // const file = await openai.files.create({
    //     file: fs.createReadStream("FILENAME.csv"),
    //     purpose: "fine-tune",
    // });

    // const response = openai.embeddings.create({
    //     model: "text-embedding-ada-002",
    //     input: "Suggest me a good book."
    // });


    const response = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
            {
                "role": "user",
                "content": userQuery
            },
            {
                "role": "system",
                "content": systemQuery
            }
            // ,{
            //     "role: assistant",
            //     "content: ""
            //     }
        ],
        temperature: 1,
        max_tokens: 256,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0,
    });
    console.log(response.choices[0].message.content);


}