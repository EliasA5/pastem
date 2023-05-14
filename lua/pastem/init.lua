
local utils = require("pastem.utils")
local M = {}

local local_config = {
	mappings = {
		["paste"] = "gp",
		["pasteline"] = "gpp",
	},
}
-- local augroup = vim.api.nvim_create_augroup('pastem', {clear = true})

-- vim.api.nvim_create_autocmd('Pastem', {
--   pattern = '',
--   group = augroup,

--   callback = function() M.paste() end
-- })

M.setup = function(config)
	M.config = vim.tbl_deep_extend("force", local_config, config or {})
	M.apply_config(M.config)
end

M.paster = function(motion)
	if motion == nil then
		vim.o.operatorfunc = "v:lua.pastem.paster"
		return "g@"
	end
	local starting = vim.api.nvim_buf_get_mark(0, "[")
	local ending = vim.api.nvim_buf_get_mark(0, "]")
	local lines = utils.get_lines()
	vim.api.nvim_buf_set_text(0, starting[1]-1, starting[2], ending[1]-1, ending[2]+1, lines)
end

M.pasterline = function(motion)
	if motion == nil then
		vim.o.operatorfunc = "v:lua.pastem.pasterline"
		return "g@l"
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = utils.get_lines()
	vim.api.nvim_buf_set_text(0, row-1, utils.get_non_zero_idx(), row-1, vim.fn.col('$')-1, lines)
end

M.apply_config = function(config)
	local function isempty(s)
		return s == nil or s == '' or s == ""
	end

	local p = config.mappings["paste"]
	if not isempty(p) then
		vim.keymap.set("n", p, require('pastem').paster, { expr = true, desc = "paste over motion", })
	end

	p = config.mappings["pasteline"]
	if not isempty(p) then
		vim.keymap.set("n", p, require('pastem').pasterline, { expr = true, desc = "paste over the current line", })
	end
end

pastem = M
return pastem
