# KLang Documentation | Lua Invocation

Most of the Lua libraries will be ported to KLang, so this would be considered an advanced feature as the average programmer wouldn't need Lua invocation.

## Example:

```c++

int main() {
    lua::call([[
        print("Hello, world!")
    ]]);
    return 0;
}

```
