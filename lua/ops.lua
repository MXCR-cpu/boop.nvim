local utils = require("utils")

-- Interacting with window processes
M = {}

M.window_virtual_text = function(window_info)
	vim.api.nvim_buf_set_extmark(window_info["bufnr"], vim.api.nvim_create_namespace("Boop Virtual Text"), 0, 0, {
		virt_lines = { { { "\\\\ Vim Boop...", "" } } },
		-- virt_lines_above = true,
		virt_text_hide = true,
	})
end

local get_visual_selection = function()
	local left_position = vim.api.nvim_buf_get_mark(0, "<")
	local right_position = vim.api.nvim_buf_get_mark(0, ">")
	left_position[1] = left_position[1] - utils._if(left_position[1] == 0, 0, 1)
	right_position[1] = right_position[1] - utils._if(right_position[1] == 0, 0, 1)
	right_position[2] = right_position[2] + 1
	local lines =
		vim.api.nvim_buf_get_text(0, left_position[1], left_position[2], right_position[1], right_position[2], {})
	return { left_position[1], left_position[2], right_position[1], right_position[2] }, lines
end

M.get_visual_selection = get_visual_selection

M.receive_text = function(window_info)
	if window_info == nil or window_info["win_id"] == nil or not vim.api.nvim_win_is_valid(window_info["win_id"]) then
		window_info = {}
		return get_visual_selection()
	end
	local pos = vim.api.nvim_win_get_cursor(tonumber(window_info["win_id"]))
	local array = vim.api.nvim_buf_get_lines(tonumber(window_info["bufnr"]), 0, pos[1] + 1, false)
	for i = 1, #array do
		array[i] = array[i]:gsub(string.rep(" ", 8), "\t")
	end
	return pos, array
end

M.set_text = function(window_info, position_array, lines_array)
	if not next(window_info) then
		vim.api.nvim_buf_set_text(
			0,
			position_array[1],
			position_array[2],
			position_array[3],
			position_array[4],
			lines_array
		)
		return
	end
	vim.api.nvim_buf_set_lines(
		window_info["bufnr"],
		position_array[1] + 2,
		position_array[1] + 1 + #lines_array,
		false,
		lines_array
	)
end

return M
