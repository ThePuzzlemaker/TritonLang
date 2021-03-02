# Triton

# NOTE
TritonLang is currently not being worked on. This is for various reasons, inclduing:
- C++ is not only very complex but is just... uh... not good
- I have no clue about making programming languages so I'd rather start making one in a language I'm more familiar with.
- I'm already working on [Calypso](https://github.com/calypso-lang/calypso). I might eventually write a Lua backend for it. I'm not sure though.
Thanks for your understanding.

## Overview

Triton is a C++ styled language that compiles directly to Lua. It is currently being written for the Minecraft mod, OpenComputers as it contains a default computer architecture/language of Lua.

## Dependencies [Included]

[Tieske/Penlight](https://github.com/Tieske/Penlight) - A set of Lua libraries [This project will specifically use its lexer library]

[mpeterv/argparse](https://github.com/mpeterv/argparse) - A command line parser for Lua inspired by Python's argparse

## Hello, world! [Currently pseudocode]

```cpp
#include <io>

int main() {
    io::info("Hello, world!");
    return 0;
}
```

## Advantages

- Headers/easily include libraries
- Compiles to Lua for OpenComputers
- Static and dynamically compile libraries into programs
- C++-style syntax and easier OOP
