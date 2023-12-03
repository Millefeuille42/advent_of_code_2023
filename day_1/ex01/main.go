package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func logErrorFatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func safeAtoi(input string) int {
	num, err := strconv.Atoi(input)
	if err != nil {
		return 0
	}
	return num
}

func convertDigit(input string) string {
	digitMap := map[string]string{
		"one":   "1",
		"two":   "2",
		"three": "3",
		"four":  "4",
		"five":  "5",
		"six":   "6",
		"seven": "7",
		"eight": "8",
		"nine":  "9",
	}

	input = strings.ToLower(input)
	if strings.ContainsAny(input, "123456789") {
		return input
	}
	return digitMap[input]
}

func parseLine(input string) int {
	re := regexp.MustCompile("[0-9]|one|two|three|four|five|six|seven|eight|nine")
	matches := make([]string, 0)

	/* Why this ?
	 * This is because strings like "eightwothree" must give ["eight", "two", "three"]
	 * The logic is then to match one by one, consume the first letter of the match (to invalidate it) and then
	 * continue to match the leftover string. Proper regexp for this could be (?=(xxx)) but the positive lookahead
	 * doesn't exist in Golang :O
	 */
	for match := re.Find([]byte(input)); len(match) > 0; match = re.Find([]byte(input)) {
		index := strings.Index(input, string(match))
		matches = append(matches, string(match))
		index += len(match)
		if len(match) > 1 {
			index -= 1
		}
		input = input[index:]
	}

	switch len(matches) {
	case 0:
		return 0
	case 1:
		return safeAtoi(convertDigit(matches[0]) + convertDigit(matches[0]))
	default:
		return safeAtoi(convertDigit(matches[0]) + convertDigit(matches[len(matches)-1]))
	}
}

func main() {
	file, err := os.Open("data.txt")
	logErrorFatal(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	res := 0
	for scanner.Scan() {
		res += parseLine(scanner.Text())
	}
	fmt.Println(res)
}
