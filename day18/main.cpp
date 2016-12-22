// MIT License

// Copyright (c) 2016 Andrew Clemons

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The centre copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <iostream>
#include <algorithm>

using namespace std;

int count_tiles(size_t grid_size, string initial_line) {
  size_t total = count(initial_line.begin(), initial_line.end(), '.');
  string last_line = initial_line;

  for (size_t i = 1; i < grid_size; i++) {
    string next_line = "";

    for (size_t j = 0; j < last_line.length(); j++) {
      char left;
      char right;
      char centre;

      if (j == 0) {
        left = '.';
        right = last_line[1];
      } else if (j == last_line.length() - 1) {
        left = last_line[last_line.length() - 2];
        right = '.';
      } else {
        left = last_line[j - 1];
        right = last_line[j + 1];
      }

      centre = last_line[j];

      if (left == '^' && centre == '^' && right == '.')  {
        next_line += "^";
      } else if (centre == '^' && right == '^' && left == '.')  {
        next_line += "^";
      } else if (centre == '.' && right == '.' && left == '^')  {
        next_line += "^";
      } else if (centre == '.' && left == '.' && right == '^')  {
        next_line += "^";
      } else {
        next_line += ".";
        total += 1;
      }
    }

    last_line = next_line;
  }

  return total;
}

int main() {
  string line;
  getline(cin, line);

  int total = count_tiles(40, line);
  cout << "There are " << total << " safe tiles\n";

  total =  count_tiles(400000, line);

  cout << "There are now " << total << " safe tiles\n";

  return 0;
}
