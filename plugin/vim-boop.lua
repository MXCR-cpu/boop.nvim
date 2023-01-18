if Loaded_boop then
	return
end

Loaded_boop = true
local boop = require("init")
local boop_test = require("tests")

vim.api.nvim_create_user_command("Boop", boop.create_window, {})

vim.api.nvim_create_user_command("BoopTest", boop_test.run_tests, {})

vim.api.nvim_create_user_command("BoopEvalJavascript", boop.eval_script("javascript"), { range = true })
vim.api.nvim_create_user_command("BoopEvalPython", boop.eval_script("python"), { range = true })
vim.api.nvim_create_user_command("BoopEvalLua", boop.eval_script("lua"), { range = true })

vim.api.nvim_create_user_command("BoopCamelCase", boop.convert("camel", ""), { range = true })
vim.api.nvim_create_user_command("BoopSnakeCase", boop.convert("snake", ""), { range = true })
vim.api.nvim_create_user_command("BoopKebabCase", boop.convert("kebab", ""), { range = true })

vim.api.nvim_create_user_command("BoopToHex", boop.convert("hex", "to"), { range = true })
vim.api.nvim_create_user_command("BoopFromHex", boop.convert("hex", "from"), { range = true })
vim.api.nvim_create_user_command("BoopToOctal", boop.convert("octal", "to"), { range = true })
vim.api.nvim_create_user_command("BoopFromOctal", boop.convert("octal", "from"), { range = true })
vim.api.nvim_create_user_command("BoopToBinary", boop.convert("binary", "to"), { range = true })
vim.api.nvim_create_user_command("BoopFromBinary", boop.convert("binary", "from"), { range = true })

vim.api.nvim_create_user_command("BoopToBase64", boop.convert("base64", "to"), { range = true })
vim.api.nvim_create_user_command("BoopFromBase64", boop.convert("base64", "from"), { range = true })
vim.api.nvim_create_user_command("BoopToSHA256", boop.convert("sha256", ""), { range = true })
