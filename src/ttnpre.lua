--[[
    Copyright (C) 2019 The Puzzlemaker
    Triton Language Preprocessor
]]

local lexer = require("lib/pllexer")
local argparse = require("lib/argparse")

local __TTNPRE_VERSION = "0.0.1-git"

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

parser:flag("-v --verbose", "Sets verbosity level (0, basic output; 1, basic verbosity - 5, super extreme debug verbosity mode)")
        :count("0-5")
        :target("verbosity")


local args = parser:parse()