import fastify from "fastify";
import queryDb from "./queryDb.js";
import spawn from "child_process";
const fastifyClient = fastify({
    logger: true
});

fastifyClient.post('/suggestions', {
    schema: {
        body: {
            type: 'object',
            additionalProperties: true
        },
        response: {
            200: {
                type: 'object',
                properties: {
                    success: { type: 'boolean' },
                    data: {
                        type: 'array',
                        additionalProperties: true
                    }
                }
            }
        }
    }
}, async (request, reply) => {
    const data = request.body;

    let questions = parseQuestions(data.questions);
    const questionsString = JSON.stringify(questions);

    console.log(questionsString);

    const py = spawn.spawnSync('python3', ['pythonTest.py'], {
        input: questionsString,
        encoding: 'utf-8'
    });

    const dataString = py.stdout;

    console.log(dataString);

    let symbolsToFetch = []
    for (let match of JSON.parse(dataString)) {
        symbolsToFetch.push([match[0], match[1]]);
    }
    symbolsToFetch = symbolsToFetch.sort((a, b) => a[1] - b[1]);
    symbolsToFetch = symbolsToFetch.slice(0, 3);

    const result = queryDb(symbolsToFetch);
    return returnCorrectResponse(result);
});

const answerMap = {
    0: "A",
    1: "B",
    2: "C",
    3: "D"
}

function parseQuestions(questionList) {
    let result = [];
    for (let i = 0; i < questionList.length; i++) {
        let question = questionList[i].question;

        let selectedChoice = question.choices
            .map((choice, index) => {
                return {
                    index: index,
                    isSelected: choice.selected
                }
            })
            .filter((choice) => choice.isSelected)[0]

        result.push({
            "question_tag": question.tag,
            "answer": answerMap[selectedChoice.index]
        })
    }
    return result;
}

function drawChartPoints() {
    let randomScalingFactor = function () {
        return Math.round;
    }
}
function returnCorrectResponse(data) {
    return {
        success: true,
        data: data
    }
}

const start = async () => {
    try {
        await fastifyClient.listen({ port: 9001, host: '0.0.0.0' });  // Corrected this line
        fastifyClient.log.info(`Server running at ${fastifyClient.server.address().port}`);
    } catch (err) {
        fastifyClient.log.error(err);
        process.exit(1);
    }
};

start();
