--[[
    Copyright (C) 2019 The Puzzlemaker
    Triton Language Preprocessor
]]

local lexer = require("lib/pllexer")
local argparse = require("lib/argparse")
local fs = require("filesystem")
local io = require("io")
local table = require("table")
local serial = require("serialization")

-- return a new array containing the concatenation of all of its 
-- parameters. Scaler parameters are included in place, and array 
-- parameters have their values shallow-copied to the final array.
-- Note that userdata and function values are treated as scalar.
function array_concat(...) 
    local t = {}
    for n = 1,select("#",...) do
        local arg = select(n,...)
        if type(arg)=="table" then
            for _,v in ipairs(arg) do
                t[#t+1] = v
            end
        else
            t[#t+1] = arg
        end
    end
    return t
end

local __TTNPRE_VERSION = "0.0.1-git"

local __TTNPRE_DEFAULT_INCLUDES = {"/usr/include", "/lib/include", "/home/include", "/home/lib/include", "/usr/lib/include", "./lib/include", "./lib", "./include"}

local argsRaw = {...}

local parser = argparse()
                :name("ttnpre")
                :description("Triton Language Preprocessor v" .. __TTNPRE_VERSION)
                :epilog("For more info, see https://github.com/ThePuzzlemaker/TritonLang")

parser:argument("input", "Input file to preprocess")
        :args(1)
        

parser:option("-o --output", "File to preprocess to (default: out.ttnpre)")
        :default("out.ttnpre")
        :argname("file")
        :overwrite(false)

parser:option("-I --includes", "Directory to find headers in")
        :argname("directory")
        :count("*")

parser:flag("-v --verbose", "Sets verbosity level (0, basic output; 1, basic verbosity - 3, super extreme debug verbosity mode)")
        :count("0-3")
        :target("verbosity")


local args = parser:parse(argsRaw)

args.includes = array_concat(args.includes, __TTNPRE_DEFAULT_INCLUDES)

-- Only do func() if verbosity is above or equal to level
function verbose(level, func)
  if args.verbosity >= level then
    func()
  end
end

print("Triton Language Preprocessor v" .. __TTNPRE_VERSION)

verbose(2, function() print("Input file: '" .. args.input .. "' | Output file: '" .. args.output .. "'") end)

verbose(2, function() print("Include directories: " .. serial.serialize(args.includes)) end)

inputFile = io.open(args.input, "r")
outputFile = io.open(args.output, "w")

if inputFile == nil then
  print("Could not open input file '" .. args.input .. "'!")
  return
elseif outputFile == nil then
  print("Could not open output file '" .. args.output .. "'!")
  return
end

local inputContent = inputFile:read("*a")

verbose(3, function() print("Input file content: \n" .. inputContent) end)

inputFile:close()
outputFile:close()