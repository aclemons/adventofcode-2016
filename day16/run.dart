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

String dragon_curve(String a) {
  var b = a.runes.toList().reversed
    .map((rune) => rune == "0".runes.toList()[0] ? "1" : "0").join();

  return (a + '0' + b);
}

String checksum(String data) {
  return new RegExp(r"(..)").allMatches(data).map((match) => match.group(1))
    .map((pair) => (pair == "00" || pair == "11") ? "1" : "0").join("");
}

String compute(int length, String line) {
  while (line.length < length) {
    line = dragon_curve(line);
  }

  line = line.substring(0, length);

  var check = checksum(line);

  while (check.length % 2 == 0) {
     check = checksum(check);
  }

  return check;
}

void main() {
  var line = stdin.readLineSync();

  var check = compute(272, line);
  stdout.writeln("The correct checksum is " + check);

  check = compute(35651584, line);
  stdout.writeln("The correct checksum for the second disk is " + check);
}
