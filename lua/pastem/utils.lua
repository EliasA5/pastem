local utils = {}

utils.get_lines = function()
	local text = vim.fn.getreg(vim.v.register)
	lines = {}
	for s in text:gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end
	return lines
end

utils.get_non_zero_idx = function()
	return vim.api.nvim_get_current_line():match("^%s*"):len()
end

return utils
