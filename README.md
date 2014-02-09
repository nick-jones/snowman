# Snowman

Snowman, ☃, is a basic UTF-8 character encoding visualiser. Given a UTF-8 encoded character, is displays information
about the component parts, and shows how the codepoint can be determined.

This is a play project, and has little practical use.

## About

Snowman outputs a textual description of a supplied character. It displays each byte in turn, indicating what the
type of byte it is in the UTF-8 context. Additionally, the binary representation of each byte is colorized, thus making
it easier to understand how the codepoint value is determined.

## Running

Simply execute the `./bin/snowman`, supplying a single character. If you wish to install Snowman to make it permanently
available, then please use [Rake](http://rake.rubyforge.org/) to build and install the application as a gem.

## Screenshot

![Screenshot](http://i.imgur.com/XKHADHr.png)