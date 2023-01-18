-- Utility Functions
M = {}

-- Operation Functions
local _if = function(bool, tru, fals)
	if bool then
		return tru
	end
	return fals
end
M._if = _if

-- String Functions
local split = function(input_string, separator)
	if separator == nil then
		separator = "%s"
	end
	local new_table = {}
	for segment in string.gmatch(input_string, "([^" .. separator .. "]+)") do
		table.insert(new_table, segment)
	end
	return new_table
end

local normalize = function(input_string)
	return split(input_string:gsub("-", " "):gsub("_", " "), " ")
end

M.split = split

M.string_slice = function(input_string, start_index, end_index)
	local return_input_string = ""
	for i = 1, #input_string do
		return_input_string = return_input_string
			.. _if(start_index <= i and i <= end_index and input_string[i], input_string[i], "")
	end
	return return_input_string
end

local array_to_single_string = function(array, input_string)
	for _, str in pairs(array) do
		input_string = input_string .. str:gsub("\\", "\\\\\\\\\\\\"):gsub("\t", "\\t"):gsub('"', '\\"') .. "\\n"
	end
	return input_string
end
M.array_to_single_string = array_to_single_string

-- Table Functions
local reorder = function(table)
	local new_table = {}
	for i = 1, #table - 1 do
		new_table[i] = table[i + 1]
	end
	return new_table
end
M.reorder = reorder

-- Environment Functions
local check_for_terminal_command = function(command)
	local return_script = vim.api.nvim_cmd(vim.api.nvim_parse_cmd("!which " .. command, {}), { output = true })
	local contains_not = _if(return_script:match("not found"), true, false)
	if contains_not then
		print("Vim-Boop: " .. command .. " not found. I requires downloading.")
	end
	return not contains_not
end

-- Converting Case Functions
M.camel_case = function(direction, array, text)
	direction = direction
	text = text or ""
	-- local string_array = split(array[1]:gsub("_", " "), " ")
	local string_array = normalize(array[1])
	for i = 1, #string_array do
		text = text
			.. _if(i == 1, string_array[i]:sub(1, 1):lower(), string_array[i]:sub(1, 1):upper())
			.. string_array[i]:sub(2, #string_array[i])
	end
	return text
end

M.snake_case = function(direction, array, text)
	direction = direction
	text = text or ""
	local string_array = normalize(array[1])
	for i = 1, #string_array do
		text = text .. string_array[i] .. _if(i == #string_array, "", "_")
	end
	return text
end

M.kebab_case = function(direction, array, text)
	direction = direction
	text = text or ""
	local string_array = split(array[1], " ")
	for i = 1, #string_array do
		text = text .. string_array[i] .. _if(i == #string_array, "", "-")
	end
	return text
end

-- Converting Number Base Functions
M.convert_hex = function(direction, array_text)
	if not next(array_text) or not string.match(type(array_text[1]), "string") then
		return ""
	end
	local conversion_directions = {
		to = function(text)
			return string.format("%x", tonumber(text:match("%d+"))):upper()
		end,
		from = function(text)
			return tostring(tonumber(text, 16))
		end,
	}
	return conversion_directions[direction](array_text[1])
end

M.convert_octal = function(direction, array_text)
	if not next(array_text) or not string.match(type(array_text[1]), "string") then
		return ""
	end
	local conversion_directions = {
		to = function(text)
			return string.format("%o", tonumber(text:match("%d+"))):upper()
		end,
		from = function(text)
			return tostring(tonumber(text, 8))
		end,
	}
	return conversion_directions[direction](array_text[1])
end

local hex_binary_conversion_table = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	["A"] = "1010",
	["B"] = "1011",
	["C"] = "1100",
	["D"] = "1101",
	["E"] = "1110",
	["F"] = "1111",
	["0000"] = "0",
	["0001"] = "1",
	["0010"] = "2",
	["0011"] = "3",
	["0100"] = "4",
	["0101"] = "5",
	["0110"] = "6",
	["0111"] = "7",
	["1000"] = "8",
	["1001"] = "9",
	["1010"] = "A",
	["1011"] = "B",
	["1100"] = "C",
	["1101"] = "D",
	["1110"] = "E",
	["1111"] = "F",
}

local decimal_to_binary = function(string)
	return string
		.format("%x", string)
		:upper()
		:gsub(".", function(digit)
			return hex_binary_conversion_table[digit]
		end)
		:match("1.*")
end

local binary_to_decimal = function(string)
	while #string % 4 ~= 0 do
		string = "0" .. string
	end
	return tostring(tonumber(
		string
			:gsub("[01][01][01][01]", function(segment)
				return hex_binary_conversion_table[segment]
			end)
			:match("[^0].*"),
		16
	))
end

M.convert_binary = function(direction, array_text)
	if not next(array_text) and type(array_text[1]) ~= "string" then
		return ""
	end
	local conversion_directions = {
		to = decimal_to_binary,
		from = binary_to_decimal,
	}
	return conversion_directions[direction](array_text[1])
end

-- Scripting Evaluation Functions
M.script_call = function(command, array_text)
	if not check_for_terminal_command(command) then
		return { "" }
	end
	local script = array_to_single_string(array_text, [[!printf "]]) .. [[" | ]] .. command
	local result = vim.api.nvim_cmd(vim.api.nvim_parse_cmd(script, {}), { output = true })
	local string_table = reorder(split(result, "\n"))
	table.insert(string_table, 1, [[\\\\ Result]])
	table.insert(string_table, 1, "")
	return string_table
end

-- Cipher Encoding/Decoding Functions
M.convert_base64 = function(direction, array_text)
	if not check_for_terminal_command("base64") then
		return ""
	elseif not next(array_text) and type(array_text[1]) ~= "string" then
		return ""
	end
	local conversion_directions = {
		to = "",
		from = " --decode",
	}
	local script = [[!printf "]] .. array_text[1] .. [[" | base64]] .. conversion_directions[direction]
	local result = vim.api.nvim_cmd(vim.api.nvim_parse_cmd(script, {}), { output = true })
	return reorder(split(result, "\n"))[1]
end

M.convert_hash = function(hash)
	return function(direction, array_text)
		direction = direction or ""
		if not check_for_terminal_command("openssl") then
			return ""
		elseif not next(array_text) and type(array_text[1]) ~= "string" then
			return ""
		end
		local script = [[!printf "]] .. array_text[1] .. [[" | openssl ]] .. hash
		local result = vim.api.nvim_cmd(vim.api.nvim_parse_cmd(script, {}), { output = true })
		return reorder(split(result, "\n"))[1]:match("%s.*"):match("%w+")
	end
end

return M
