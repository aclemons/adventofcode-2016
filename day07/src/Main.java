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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 */
public class Main {

    /**
     * @param args
     * @throws IOException
     */
    public static void main(final String[] args) throws IOException {
        final Pattern tlsPattern         = Pattern.compile("([^\\[\\]])(?!\\1)([^\\[\\]])\\2\\1");
        final Pattern tlsNegativePattern = Pattern.compile("\\[[^\\[\\]]*([^\\[\\]])(?!\\1)([^\\[\\]])\\2\\1[^\\[\\]]*\\]");
        final Pattern sslPattern         = Pattern.compile("([^\\[\\]])(?!\\1)([^\\[\\]])\\1[^\\[\\]]*(\\[[^\\[\\]]+\\])?[^\\[\\]]*(\\[[^\\[\\]]+\\])?[^\\[\\]]*\\[[^\\[\\]]*\\2\\1\\2[^\\[\\]]*\\]");
        final Pattern sslPattern2        = Pattern.compile("\\[[^\\[\\]]*([^\\[\\]])(?!\\1)([^\\[\\]])\\1[^\\[\\]]*\\][^\\[\\]]*(\\[[^\\[\\]]+\\])?[^\\[\\]]*(\\[[^\\[\\]]+\\])?[^\\[\\]]*\\2\\1\\2");

        try (final BufferedReader in = new BufferedReader(new InputStreamReader(System.in))) {
            final Stream<boolean[]> results = in.lines()
                .map(line -> new boolean[] {
                        tlsPattern.matcher(line).find() && !tlsNegativePattern.matcher(line).find(),
                        sslPattern.matcher(line).find() || sslPattern2.matcher(line).find()
                    });

            final long[] counts = results.reduce(new long[] { 0, 0 },
                                                 (sum, line) -> new long[] { sum[0] + (line[0] ? 1 : 0), sum[1] + (line[1] ? 1 : 0) },
                                                 (sum1, sum2) -> new long[] { sum1[0] + sum2[0], sum1[1] + sum2[1] });

            System.out.println(String.format("%s IPs support TLS", Long.toString(counts[0])));
            System.out.println(String.format("%s IPs support SSL", Long.toString(counts[1])));
        }
    }
}
