package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	floors := make([][]string, 4)

	for i := 0; i < 4; i++ {
		floors[i] = make([]string, 0)
	}

	parser, _ := regexp.Compile("a ([^ ]+) ([^ ]+)[\\.,]")
	scanner := bufio.NewScanner(os.Stdin)

	floor := 0
	for scanner.Scan() {
		line := scanner.Text()

		results := parser.FindAllStringSubmatch(line, -1)

		for _, data := range results {
			first := strings.Replace(data[1], "-compatible", "", -1)
			second := data[2]

			floors[floor] = append(floors[floor], first+" "+second)
		}

		fmt.Println(floors[floor])

		floor++
	}

	elevator := 1

	if elevator != 1 {

	}

}
