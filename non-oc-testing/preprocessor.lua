require("pl")
local serial = dofile("./serialization.lua")
local yield = coroutine.yield


local text = [[
#include <io>
#include "eek.h"
#define __TEXT
#
-- runtime comment, will be in lua file
// compile comment, will NOT be in lua file
#define test
#define TEST2 1
]]

local function include_dump(tok, options, findres, localInc)
    if localInc then
        return yield("include_local", findres[3])
    else
        return yield("include_global", findres[3])
    end
end

local function define_dump(tok, options, findres, withValue)
    if withValue then
        return yield("valued_define." .. findres[3], findres[4])
    else
        return yield("define", findres[3])
    end
end

local function fallback(tok)
    return yield(tok,tok)
end

local function preprocessor(tok, options, findres) 
    if findres[3] == "include" then
        local findres2 = {}
        local localInc = false
        if string.match(tok, "^#include <([A-Za-z0-9/.\\-_]*)>") then
            findres2 = {string.find(tok, "^#include <([A-Za-z0-9/.\\-_]*)>")}
        elseif string.match(tok, "^#include \"([A-Za-z0-9/.\\-_]*)\"") then
            findres2 = {string.find(tok, "^#include \"([A-Za-z0-9/.\\-_]*)\"")}
            localInc = true
        else
            error("Invalid include!")
        end
        return include_dump(tok, options, findres2, localInc)
    elseif findres[3] == "define" then
        local findres2 = {}
        local withValue = false
        if string.match(tok, "^#define ([A-Za-z0-9_\\-]*) ([^\n^\r^ ]*)") then
            findres2 = {string.find(tok, "^#define ([A-Za-z0-9_\\-]*) ([^\n^\r^ ]*)")}
            withValue = true
        elseif string.match(tok, "^#define ([A-Za-z0-9_\\-]*)") then
            findres2 = {string.find(tok, "^#define ([A-Za-z0-9_\\-]*)")}
        else
            error("Invalid define!")
        end
        return define_dump(to, options, findres2, withValue)
    elseif findres[3] == "" then
        return yield("preprocessor", "noop")
    else
        return yield("preprocessor", findres[3])
    end
end

local function runtime_comment(tok, options, findres)
    return yield("runtime_comment", findres[3])
end

local function compile_comment(tok, options, findres)
    return yield("compile_comment", findres[3])
end

local matches = {{
    '^#([A-Za-z]*[0-9]*)([^\n^\r]*)([\r]?[\n]?)',
    preprocessor
},
{
    '^%-%-([^\n^\r]*)([\r]?[\n]?)',
    runtime_comment
},
{
    '^//([^\n^\r]*)([\r]?[\n]?)',
    compile_comment
},
{
    '^.',
    fallback
}}


local tokens = lexer.scan(text, matches)
for t,v in tokens do
    print(t, v)
end
