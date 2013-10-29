local log = require('util.logger')
local utils = require('util.utils')

local M = {}

local FOLDER = "/tmp/"
local FILE_PREFIX = "d3d-"
local FILE_EXTENSION = ".txt"

function getPath(fileName) 
	return FOLDER..FILE_PREFIX..fileName..FILE_EXTENSION
end

function M.get(fileName)
	local path = getPath(fileName)
	local file, error = io.open(path,'r')
	if file == nil then
		--log:error("Util:Access:Can't read controller file. Error: "..error)
		return "",""
	else
		local status = file:read('*a')
		file:close()
		local code, msg = string.match(status, '([^|]+)|+(.*)')
		code = tonumber(code)
		return code,msg
	end
end

function M.set(fileName,code,msg)
	--log:info("setStatus: "..code.." | "..msg)
	local path = getPath(fileName)
	local file = io.open(path,'w')
	file:write(code.."|"..msg)
	file:flush()
	file:close()
end

return M
