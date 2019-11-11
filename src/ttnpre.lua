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
local os = require("os")

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

-- explode(seperator, string)
function explode(d,p)
   local t, ll
   t={}
   ll=0
   if(#p == 1) then
      return {p}
   end
   while true do
      l = string.find(p, d, ll, true) -- find the next d in the string
      if l ~= nil then -- if "not not" found then..
         table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
         ll = l + 1 -- save just after where we found it for searching next time.
      else
         table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
         break -- Break at end, as it should be, according to the lua manual.
      end
   end
   return t
end

local __TTNPRE_VERSION = "0.0.1-git"

local __TTNPRE_DEFAULT_INCLUDES = {"/usr/include", "/lib/include", "/usr/lib/include", "/home/include", "/home/lib/include", "./lib/include", "./lib", "./include"}

local __TTNPRE_DEFAULT_VPREDEFS = {{"__TNTNPRE_VERSION__", __TTNPRE_VERSION}}

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
        :count(1)
        :overwrite(false)

parser:option("-I --includes", "Directory to find headers in (ORDER SENSITIVE). You can also use the $INCLUDES environment variable (separated by ':')")
        :argname("directory")
        :count("*")

parser:option("-P --vpredefines", "Predefined macros WITH values (equivalent to '#define <identifier> <value>')")
        :args(2)
        :argname({"identifier", "value"})
        :count("*")

parser:option("-p --predefines", "Predefined macros WITHOUT values (equivalent to '#define <identifier>')")
        :argname("identifier")
        :count("*")

parser:flag("-v --verbose", "Sets verbosity level (0, basic output; 1, basic verbosity - 3, super extreme debug verbosity mode)")
        :count("0-3")
        :target("verbosity")

parser:option("--ttncmpv")
        :count(1)
        :hidden(true)
        :default(__TTNPRE_VERSION)

parser:option("--ttnlinkv")
        :count(1)
        :hidden(true)
        :default(__TTNPRE_VERSION)

local args = parser:parse(argsRaw)

local environmentIncludes = explode(":", os.getenv("INCLUDES"))

args.includes = array_concat(args.includes, __TTNPRE_DEFAULT_INCLUDES, environmentIncludes)
args.vpredefines = array_concat(args.vpredefines, __TTNPRE_DEFAULT_VPREDEFS, {{"__TTNLINK_VERSION__", args.ttnlinkv}, {"__TTNCMP_VERSION__", args.ttncmpv}})

-- Only do func() if verbosity is above or equal to level
function verbose(level, func)
  if args.verbosity >= level then
    func()
  end
end

print("Triton Language Preprocessor v" .. __TTNPRE_VERSION)

verbose(2, function() print("Input file: '" .. args.input .. "' | Output file: '" .. args.output .. "'") end)

verbose(2, function() print("Include directories: " .. serial.serialize(args.includes)) end)

verbose(2, function() print("Valued predefines: " .. serial.serialize(args.vpredefines)) end)

verbose(2, function() print("Predefines: " .. serial.serialize(args.predefines)) end)

local inputFile = io.open(args.input, "r")
local outputFile = io.open(args.output, "w")

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