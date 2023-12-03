package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
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

func parseLine(input string) int {
	re := regexp.MustCompile("[0-9]")
	matches := re.FindAllString(input, -1)

	switch len(matches) {
	case 0:
		return 0
	case 1:
		return safeAtoi(matches[0] + matches[0])
	default:
		return safeAtoi(matches[0] + matches[len(matches)-1])
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
