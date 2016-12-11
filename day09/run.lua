-- MIT License

-- Copyright (c) 2016 Andrew Clemons

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local function decompress(line, recurse, total)
  local x = line:find('%(')

  if x == nil then
    return total + line:len()
  end

  local length = total

  if not(x == 1) then
    local prefix = line:sub(1, x - 1)

    if not(prefix == nil) then
      length = length + prefix:len()
    end
  end

  local y = line:find('%)', x + 1)

  local instruction  = line:sub(x + 1, y - 1)
  local char_count   = tonumber(instruction:sub(1, instruction:find('x') - 1))
  local repeat_count = tonumber(instruction:sub(instruction:find('x') + 1))

  local decompressed = line:sub(y + 1, y + char_count):rep(repeat_count)
  local remaining    = line:sub(y + char_count + 1)

  if recurse then
    remaining = decompressed .. remaining
  else
    length = length + decompressed:len()
  end

  return decompress(remaining, recurse, length)
end

local line = io.stdin:read()

local decompressed_length = decompress(line, false, 0)
print("The decompressed length of the file is " .. decompressed_length)

local decompressed_length_v2 = decompress(line, true, 0)
print("The decompressed length of the file using the improved format is " .. decompressed_length_v2)
