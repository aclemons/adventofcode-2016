#!/usr/bin/env julia

# MIT License

# Copyright (c) 2016-2017 Andrew Clemons

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

type Elf
    id::UInt32
    presents::UInt32
end

function initCircle(count)
    elves = Array{Elf, 1}()

    for i in 1:count
        elf = Elf(i, 1)
        push!(elves, elf)
    end

    elves
end

function winningElf(count)
    elves = initCircle(count)

    while length(elves) > 1
        first = shift!(elves)
        second = shift!(elves)

        first.presents = first.presents + second.presents

        push!(elves, first)
    end

    elf = pop!(elves)

    @printf "Elf %d now gets all the presents\n" elf.id
end

function winningElfV2(count)
    elves = initCircle(count)

    len = length(elves)

    offset = 1
    while len > 1
        first = elves[offset]

        opposite = offset + convert(UInt32, round((len / 2), RoundDown))

        if opposite > len
            opposite = opposite - len
        end

        second = elves[opposite]
        deleteat!(elves, opposite)

        first.presents = first.presents + second.presents

        len = length(elves)

        if len > 1
            if opposite > offset
                offset += 1
            else
                if offset > len
                    offset = 1
                end
            end
        end
    end

    elf = pop!(elves)

    @printf "Elf %d now gets all the presents\n" elf.id
end

count = parse(UInt32, chomp(readline()))

winningElf(count)
winningElfV2(count)
