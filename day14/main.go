// MIT License

// Copyright (c) 2016 Andrew Clemons

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package main

import (
	"bufio"
	"crypto/md5"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strings"
)

const targetKey int = 64

func BuildMatcher(count int) *regexp.Regexp {
	var pattern = ""
	for i := 0; i < 16; i++ {
		hex := fmt.Sprintf("%x", i)

		if i != 0 {
			pattern = pattern + "|"
		}

		pattern = fmt.Sprintf("%s%s", pattern, strings.Repeat(hex, count))
	}

	expression, _ := regexp.Compile(pattern)

	return expression
}

func SortedKeys(inputmap map[int]string) []int {
	sorted := make([]int, len(inputmap))

	i := 0
	for k := range inputmap {
		sorted[i] = k
		i++
	}

	sort.Ints(sorted)

	return sorted
}

func FindTriples(triple_pattern *regexp.Regexp, potential_map map[int]string, hash string, index int) {
	matching_triples := triple_pattern.FindStringSubmatch(hash)

	if matching_triples != nil {
		triple := matching_triples[0]
		potential_map[index] = string(triple[0])
	}
}

func FindQuintuples(quintuple_pattern *regexp.Regexp, potential_map map[int]string, key_map map[int]string, hash string, index int) {
	matching_quintuples := quintuple_pattern.FindAllStringSubmatch(hash, -1)

	if matching_quintuples != nil {
		for _, quintuples := range matching_quintuples {
			for _, quintuple := range quintuples {
				digit := string(quintuple[0])

				sorted_keys := SortedKeys(potential_map)

				for _, key := range sorted_keys {

					if (index - key) > 1000 {
						delete(potential_map, key)
					} else if index != key {
						value := potential_map[key]

						if value == digit {
							delete(potential_map, key)

							key_map[key] = value
						}
					}
				}
			}
		}
	}
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	if !scanner.Scan() {
		panic("Input?")
	}

	salt := scanner.Text()

	// go regex engine does not support backreferences
	// triple, _ := regexp.Compile("(\\.)\\1{2}")
	// quintuple, _ := regexp.Compile("(\\.)\\1{4}")
	triple_pattern := BuildMatcher(3)
	quintuple_pattern := BuildMatcher(5)

	potential_keys := make(map[int]string)
	keys := make(map[int]string)

	potential_stretched_keys := make(map[int]string)
	stretched_keys := make(map[int]string)

	var remaining = 1000

	for current_index := 0; remaining > 0; current_index++ {
		if len(keys) >= targetKey && len(stretched_keys) >= targetKey {
			remaining--
		}

		hash := fmt.Sprintf("%x", md5.Sum([]byte(fmt.Sprintf("%s%d", salt, current_index))))

		var stretched_hash = hash
		for i := 0; i < 2016; i++ {
			stretched_hash = fmt.Sprintf("%x", md5.Sum([]byte(stretched_hash)))
		}

		FindTriples(triple_pattern, potential_keys, hash, current_index)
		FindQuintuples(quintuple_pattern, potential_keys, keys, hash, current_index)

		FindTriples(triple_pattern, potential_stretched_keys, stretched_hash, current_index)
		FindQuintuples(quintuple_pattern, potential_stretched_keys, stretched_keys, stretched_hash, current_index)
	}

	sorted := SortedKeys(keys)
	stretched_sorted := SortedKeys(stretched_keys)

	fmt.Printf("The index which produces the %dth one-time pad key is %d\n", targetKey, sorted[targetKey-1])
	fmt.Printf("The index which produces the %dth one-time pad key using the strechted algorithm is %d\n", targetKey, stretched_sorted[targetKey-1])
}
