const events = require('events')
const fs = require('fs')
const readline = require('readline')

function readLine(readCallback, closeCallback) {
    const rl = readline.createInterface({
        input: fs.createReadStream('ex01/data.txt'),
        crlfDelay: Infinity
    })

    rl.on('line', readCallback)
    events.once(rl, 'close').then(closeCallback)
}

const powers = []

readLine(
    line => {
        const numberColorGroups = line.matchAll(/(?<number>\d+)\s+(?<color>green|blue|red)/g)
        const maxColorMap = {
            "red": 0,
            "blue": 0,
            "green": 0
        }
        for (const match of numberColorGroups) {
            const number = parseInt(match.groups.number, 10)
            console.log("matching",  maxColorMap[match.groups.color], "against", number)
            if (maxColorMap[match.groups.color] < number) {
                console.log("Assigning", number)
            }

            maxColorMap[match.groups.color] = maxColorMap[match.groups.color] < number
                ? number
                : maxColorMap[match.groups.color]
        }

        console.log(maxColorMap)
        const power = Object.values(maxColorMap).reduce((accumulator, currentValue) => {
            return accumulator * currentValue;
        }, 1)
        console.log(power)
        powers.push(power)
    },
    () => {
        const sum = powers.reduce((accumulator, currentValue) => {
            return accumulator + parseInt(currentValue, 10)
        }, 0)

        console.log(sum)
    }
)
