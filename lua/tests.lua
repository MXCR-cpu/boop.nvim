local utils = require("utils")
-- local ops = require("ops")

M = {}

M.run_tests = function()
	local string_sentences = { "here is an example", "hereIsAnExample", "here_is_an_example", "here-is-an-example" }
	local cases = { "camel_case", "snake_case", "kebab_case" }
	local passed_test = true
	for index = 1, #cases do
		local result = utils[cases[index]]("To", { string_sentences[1] }, "")
		if result ~= string_sentences[1 + index] then
			passed_test = false
			print(
				"Boop: case "
					.. cases[index]
					.. ': failed to convert to case sentence, "'
					.. string_sentences[1]
					.. '" x--> "'
					.. result
					.. '"'
			)
		end
	end
	if passed_test then
		print("Boop: All Tests Passed ✓")
	end
end

return M
