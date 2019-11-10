# Triton

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