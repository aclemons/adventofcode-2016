" MIT License "

" Copyright (c) 2017 Andrew Clemons "

" Permission is hereby granted, free of charge, to any person obtaining a copy "
" of this software and associated documentation files (the 'Software'), to deal "
" in the Software without restriction, including without limitation the rights "
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell "
" copies of the Software, and to permit persons to whom the Software is "
" furnished to do so, subject to the following conditions: "

" The above copyright notice and this permission notice shall be included in all "
" copies or substantial portions of the Software. "

" THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR "
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, "
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE "
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER "
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, "
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE "
" SOFTWARE. "

intervals := OrderedCollection new.
infinity := 10000000. " not really :) "

(stdin upToEnd substrings: Character lf) collect: [:line |
  (line =~ 'Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)') ifMatched: [:match |

    index := (match at: 1) asNumber.
    positions := (match at: 2) asNumber.
    position := (match at: 3) asNumber.
    start := positions - position - index.

    (start < 0) ifTrue: [start := start + positions].

    intervals add: (Interval from: start to: infinity by: positions).
  ].
].

calculate := [
  streams := intervals collect: [:interval | interval readStream].
  values := streams collect: [:stream | stream next].

  [((Set withAll: values) size) = 1] whileFalse: [
    (Interval from: 1 to: (streams size)) do: [:index |
      other_index := 1.

      values do: [:other |
        other_index = index ifFalse: [
          [(values at: index) < other] whileTrue: [
            stream := streams at: index.
            values at: index put: (stream next).
          ].
        ].

        other_index := other_index + 1
      ].
    ].
  ].

  values.
].

Transcript show: 'The first time you can press the button to get a capsule is: ', (calculate value at: 1) asString.
Transcript cr.

interval := Interval from: 4 to: infinity by: 11.
intervals add: interval.

Transcript show: 'The first time you can press the button to get another capsule is: ', (calculate value at: 1) asString.
Transcript cr.
