# Triton

## Overview

Triton is a C++ styled language that compiles directly to Lua. It is currently being written for the Minecraft mod, OpenComputers as it contains a default computer architecture/language of Lua.

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