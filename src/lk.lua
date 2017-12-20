-- lk exec w/o shebang ('#!/bin/env lua')
-- LuaK: C/C++-Style Lua
local pl = require("pl")
local lexer = require("pl.lexer")
local file = require("pl.file")
local path = require("pl.path")

local args = {...}

local lk = { ["_VERSION"] = "1.0.0-DEV" }

lk.optsTable = { ["lib"] = nil, ["verbose"] = nil, ["validate"] = nil, ["interpret"] = nil }

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function string.split(d,p)
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

function lk.checkFileExists(filePath)
	if path.exists(filePath) and path.isfile(filePath) then
		return true
	else
		return false
	end
end

function lk.checkDirectoryExists(dirPath)
	if path.exists(dirPath) and path.isdir(dirPath) then
		return true
	else
		return false
	end
end

-- In case I use exit() instead of os.exit() (used to Python's exit() :p)
function exit(i)
	 os.exit(i) 
end

-- Table to newline-terminated string
function lk.tableToNLTString(tbl)
	str = ""
	for i,v in ipairs(tbl) do
		if i == #tbl then
			str = str .. v
		else 
			str = str .. v .. "\n"
		end
	end
	return str
end

function lk.parseOpts(args) 
	tabstr = lk.tableToNLTString(args)
	tok = lexer.scan(tabstr,nil,{space=false})
	local t,v = tok()
	while t ~= nil do
		if v == 'l' then
			lk.optsTable.lib = true
		elseif v == 'v' then
			lk.optsTable.verbose = true
		elseif v == 'i' then 
			lk.optsTable.interpret = true
		elseif v == 'V' then
			lk.optsTable.validate = true
		elseif v == '-' then
			-- Do nothing
		elseif t == 'space' then
			-- Do nothing
		elseif t == 'iden' then
			-- Probably a file name; do nothing
		elseif t == 'string' then
			-- Probably a file name; do nothing
		elseif t == '/' then
			-- Probably a file name; do nothing
		elseif t == '\\' then
			-- Probably a file name; do nothing
		elseif t == '.' then
			-- Probably a file name; do nothing
		else
			print("[ERROR] Unrecognized option: '-" .. v .. "'")
			exit()
		end
		t,v = tok()
	end
end

function lk.checkOpts()
	if lk.optsTable["lib"] and lk.optsTable["validate"] then
		print("[ERROR] Options '-l' and '-V' are not compatible.")
		exit(-1)
	elseif lk.optsTable["lib"] and lk.optsTable["interpret"] then
		print("[ERROR] Options '-l' and '-i' are not compatible.")
		exit(-1)
	elseif lk.optsTable["interpret"] and lk.optsTable["validate"] then
		print("[ERROR] Options '-i' and '-V' are not compatible.")
		exit(-1)
	else
		if lk.optsTable["verbose"] then
			print("[INFO] All options compatible.")
		end
	end
end

function lk.lex(inputCont)
	local fileTab = string.split("\n", inputCont)
	-- Lexer table example
	--[[
		{
			{
				{"type"="#","value"="#"},
				{"type"="iden","value"="include"},
				{"type"="space","value"=" "},
				{"type"="<","value"="<"},
				{"type"="iden","value"="io"},
				{"type"=">","value"=">"}
			},
			...etc...50 million more lines...etc...
		}
	--]]
	local lexerTable = {}
	for i,l in ipairs(fileTab) do
		local line = {}
		for t,v in lexer.scan(l, nil, {space=false}) do
			table.insert(line,{["type"]=t,["value"]=v})
		end
		table.insert(lexerTable,line)
	end
	-- The confusing part (to me :p): converting this mess of a table (https://hastebin.com/isipedisiy) to a much more appealing table (https://hastebin.com/lodisoragu)
	-- WIP: Actual parsing from raw tokens to more descriptive tokens
end

if #args < 2 then
	print("Usage: lk [OPTIONS] <file> <output>       ")
	print("       -l : Compile as library.           ")
	print("       -v : Verbose.                      ")
	print("       -i : Don't compile, just interpret.")
	print("       -V : Just validate the file.       ")	
else
	lk.parseOpts(args)			
	if lk.optsTable["verbose"] then
		print("[INFO] KLang Version " .. lk["_VERSION"] .. ".")
	end
	lk.checkOpts()
	if lk.optsTable["verbose"] then
		print("[INFO] KLang Options: ")
		if lk.optsTable["lib"] then
			print("       Library:      On ")
		else
			print("       Library:      Off")
		end
		if lk.optsTable["verbose"] then
			print("       Verbose:      On ")
		else
			print("       Verbose:      Off")
		end
		if lk.optsTable["validate"] then
			print("       Validate:     On ")
		else
			print("       Validate:     Off")
		end
		if lk.optsTable["interpret"] then
			print("       Interpret:    On ")
		else
			print("       Interpret:    Off")
		end
		if args[#args-1] == nil then
			print("[ERROR] No input file argument found.")
			exit(-1)
		elseif args[#args] == nil then
			print("[ERROR] No output file argument found.")
			exit(-1)
		end
	end
	local inputPath = args[#args-1]
	local outputPath = args[#args]
	if not lk.checkFileExists(inputPath) then
		print("[ERROR] Input file '" .. inputPath .. "' doesn\'t exist.") 
		exit(-1)
	end
	if lk.checkFileExists(outputPath) then
		print("[WARNING] Output file '" .. outputPath .. "' will be overwritten.")
	end
	if lk.optsTable["verbose"] then
		print("[INFO] Input file: '" .. inputPath .. "'.")
		print("[INFO] Output file: '" .. outputPath .. "'.") 
	end
	local inputCont = file.read(inputPath)
	if inputCont == nil then
		print("[ERROR] Unknown error opening input file. (Do you have the correct permissions?). ")
		exit(-1);
	end
	lk.lex(inputCont)
	exit(0)
end

