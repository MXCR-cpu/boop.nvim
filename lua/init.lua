local plenary = require("plenary.window.float")
local utils = require("utils")
local ops = require("ops")

M = {}

-- Neovim Function definitions
M.window = {}

M.create_window = function()
	local win_opts = {
		winblend = 5,
		percentage = 0.5,
	}
	local border_opts = {
		topleft = "┌",
		topright = "┐",
		top = "─",
		left = "│",
		right = "│",
		botleft = "└",
		botright = "┘",
		bot = "─",
	}
	M.window = plenary.percentage_range_window(0.5, 0.5, win_opts, border_opts)
	-- ops.window_virtual_text(M.window)
end

M.eval_script = function(language)
	return function()
		local script_command = {
			javascript = "node",
			python = "python3",
			lua = "lua",
		}
		if not script_command[language] then
			return
		end
		local pos, array_text = ops.receive_text(M.window)
		if not array_text or not next(array_text) then
			return
		end
		ops.set_text(M.window, pos, utils.script_call(script_command[language], array_text))
	end
end

M.convert = function(item, direction)
	return function()
		local conversion_functions = {
			-- Cases
			camel = utils.camel_case,
			snake = utils.snake_case,
			kebab = utils.kebab_case,
			-- Number Bases
			hex = utils.convert_hex,
			octal = utils.convert_octal,
			binary = utils.convert_binary,
			-- Encodings
			base64 = utils.convert_base64,
			sha256 = utils.convert_hash("sha256"),
			sha512 = utils.convert_hash("sha512"),
			sha1 = utils.convert_hash("sha1"),
		}
		if not conversion_functions[item] then
			print("Vim-Boop: " .. item .. " conversion not defined")
			return
		end
		local pos, array_text = ops.receive_text(M.window)
		if not array_text or not next(array_text) then
			return
		end
		ops.set_text(M.window, pos, { conversion_functions[item](direction, array_text) })
	end
end

return M
