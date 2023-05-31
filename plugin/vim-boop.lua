local api = vim.api
if Loaded_boop then
	return
end
Loaded_boop = true
local boop = require("init")
local boop_test = require("tests")
local commands = {
	javascript = boop.eval_script("javascript", "node"),
	lua = boop.eval_script("lua", "lua"),
	python = boop.eval_script("python", "python3"),
	scheme = boop.eval_script("scheme", "chez | tail -n 1 | cut -d '>' -f 2,2"),
}
local direction = {"to", "from"}
local base = {"hex", "octal", "binary", "base64"}
local parse = function(args)
	return vim.split(vim.trim(args), "%s+")
end
local complete = function(cmd, prefix)
	local plugins = {}
	for name, _ in pairs(commands) do
		plugins[#plugins + 1] = name
	end
	table.sort(plugins)
	return plugins
end

api.nvim_create_user_command("Boop", boop.create_window, {})
api.nvim_create_user_command("BoopTest", boop_test.run_tests, {})
api.nvim_create_user_command("BoopEval", function(cmd)
	local args = parse(cmd.args)
	commands[args[1]]()
end, {
	range = true,
	nargs = "?",
	complete = function(_, line)
		local args = parse(line)
		if #args > 1 then
			return complete(prefix, args[#args])
		end
		return vim.tbl_keys(commands)
	end
})
api.nvim_create_user_command("BoopConvert", function(cmd)
	local args = parse(cmd.args)
	boop.convert(args[2], args[1])()
end, {
	range = true,
	nargs = "?",
	complete = function(_, line)
		local args = parse(line)
		if #args >= 2 then
			return base
		end
		return direction
	end
})
api.nvim_create_user_command("BoopCamelCase", boop.convert("camel", ""), { range = true })
api.nvim_create_user_command("BoopSnakeCase", boop.convert("snake", ""), { range = true })
api.nvim_create_user_command("BoopKebabCase", boop.convert("kebab", ""), { range = true })
api.nvim_create_user_command("BoopToSHA256", boop.convert("sha256", ""), { range = true })
