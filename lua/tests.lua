local utils = require("utils")
-- local ops = require("ops")

M = {}

M.run_tests = function()
	local string_sentences = { "here is an example", "hereIsAnExample", "here_is_an_example", "here-is-an-example" }
	local cases = { "camel_case", "snake_case", "kebab_case" }
	for index = 1, #cases do
		if utils[cases[index]]("To", {}, string_sentences[1]) ~= string_sentences[1 + index] then
			print("case " .. cases[index] .. " failed to convert to regular sentence")
		end
	end
end

return M
