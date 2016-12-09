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

use std::io;

extern crate crypto;
use crypto::md5::Md5;
use crypto::digest::Digest;

extern crate pcre;
use pcre::Pcre;

use std::str::FromStr;

fn password(input: String) -> (String, String) {
    let mut i = 0;

    let mut password = String::new();
    let empty = ' ';
    let mut passwordv2 = vec![empty; 8];

    let prefix = std::iter::repeat("0").take(5).collect::<String>();
    let pattern = format!("^{}(.)(.)", prefix);
    let mut re = Pcre::compile(&pattern).unwrap();

    let mut md5 = Md5::new();

    loop {
        let next_string = format!("{}{}", input, i.to_string());

        md5.input_str(&next_string);

        let md5sum = md5.result_str();

        md5.reset();

        let matcher = re.exec(&md5sum);

        if matcher.is_some() {
            let result = matcher.unwrap();

            if password.len() < 8 {
                password.push_str(result.group(1));
            }

            if passwordv2.contains(&empty) {
                let index_result = i32::from_str(result.group(1));

                if index_result.is_ok() {
                    let index = index_result.unwrap();
                    if index >= 0 && index < 8 && passwordv2[index as usize] == empty {
                        let letter = result.group(2).to_string().chars().next().unwrap();
                        passwordv2[index as usize] = letter;
                    }
                }
            }

            if password.len() == 8 && !passwordv2.contains(&empty) {
                break;
            }
        }

        i += 1
    }

    (password, passwordv2.iter().fold("".to_string(), |mut i, j| { i.push(*j); i }))
}

fn main() {
    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("Invalid input");

    let (password, passwordv2) = password(input.trim().to_string());

    println!("The password for the door is {}", password);
    println!("The password for the door using the new method is {}", passwordv2);
}
