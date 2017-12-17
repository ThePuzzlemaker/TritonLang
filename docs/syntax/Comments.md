# KLang Docs | Comments

In Klang, you can use normal Lua comments or KLang comments.

## KLang Comments

KLang Comments start with `//`, and will be removed while compiling to Lua.

### Example:

```c++
#include <io>

// Hello, world!
int main() {
    io::print("Hello, world!");
    return 0;
}

```

#### Compiled Code:

```lua
local lk = require "lk.core"
local io = lk.usingLibrary(io)

io.print("Hello, world!")
os.exit(0)
```

## Lua Comments

Lua Comments start with `--`, and will not be removed while compiling to lua.

### Example:

``` c++
#include <io>

-- Hello, world!
int main() {
    io::print("Hello, world!");
    return 0;
}

```

#### Compiled Code:

```lua
local lk = require "lk.core"
local io = lk.usingLibrary(io)

-- Hello, world!
io.print("Hello, world!")
os.exit(0)
```

[Back to Homepage](/KLang/)
