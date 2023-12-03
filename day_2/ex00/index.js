const events = require('events')
const fs = require('fs')
const readline = require('readline')

function readLine(readCallback, closeCallback) {
    const rl = readline.createInterface({
        input: fs.createReadStream('ex00/data.txt'),
        crlfDelay: Infinity
    })

    rl.on('line', readCallback)
    events.once(rl, 'close').then(closeCallback)
}

const validGameIds = []
const colorMap = {
    "red": 12,
    "green": 13,
    "blue": 14
}


readLine(
    line => {
        const gameIdMatch = line.match(/Game\s+(?<id>\d+)/)
        const gameId = gameIdMatch ? gameIdMatch.groups.id : null

        const numberColorGroups = line.matchAll(/(?<number>\d+)\s+(?<color>green|blue|red)/g)
        for (const match of numberColorGroups) {
            const number = parseInt(match.groups.number, 10)
            if (colorMap[match.groups.color] < number) return
        }

        validGameIds.push(gameId)
    },
    () => {
        const sum = validGameIds.reduce((accumulator, currentValue) => {
            return accumulator + parseInt(currentValue, 10)
        }, 0)

        console.log(sum)
    }
)
