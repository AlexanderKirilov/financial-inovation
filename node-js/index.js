// This code is for v4 of the openai package: npmjs.com/package/openai
import { OpenAI } from "openai";
import dotenv from "dotenv";

dotenv.config();
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});
//TODO: Get query from system
await main();


async function main() {
    // const file = await openai.files.create({
    //     file: fs.createReadStream("FILENAME.csv"),
    //     purpose: "fine-tune",
    // });

    // const response = openai.embeddings.create({
    //     model: "text-embedding-ada-002",
    //     input: "Suggest me a good book."
    // });



    const systemQuery =
        `You are a financial advisor aiming to provide the user with valuable financial advice to choose an ETF according to characteristics which will be given in the query. You will be provided with a .csv formatted text string with information about some ETFs. The columns of the file describe the following: {id, name, risk, sustainability, five-year performance, etc...}.

        Suggest the user an ETF from the ones provided based on their indicated risk profile. Return the id, and performance from 2017, in json format.`;

    const userQuery = "I am a risk-averse investor interested in sustainability, please recommend me some ETFs to invest in";

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
    console.log(response);
    console.log(response.choices[0].message.content);
}