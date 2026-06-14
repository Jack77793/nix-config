vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-- nvim
map("n", "sv", "<Cmd>vsp<CR>", opts)
map("n", "sb", "<Cmd>sp<CR>", opts)
map("n", "sc", "<C-w>c", opts)
map("n", "so", "<C-w>o", opts)
map("n", "sh", "<C-w>h", opts)
map("n", "sj", "<C-w>j", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sl", "<C-w>l", opts)
-- toggleterm
map("n", "tt", "<Cmd>ToggleTerm direction=float<CR>", opts)
-- hop
map("n", "fj", "<Cmd>HopWord<CR>", opts)
-- barbar
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)

map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)

map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
map("n", "<A-q>", "<Cmd>BufferClose<CR>", opts)
map("n", "<A-b>", "<Cmd>BufferPick<CR>", opts)
-- codewindow
-- vim.keymap.set("n", "mo", require("codewindow").open_minimap)
-- vim.keymap.set("n", "mc", require("codewindow").close_minimap)
-- vim.keymap.set("n", "mm", require("codewindow").toggle_minimap)
-- vim.keymap.set("n", "mf", require("codewindow").toggle_focus)

-- incremental selection treesitter/lsp
vim.keymap.set({ "n", "x", "o" }, "<CR>", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<BS>", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })
