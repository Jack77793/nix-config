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
-- telescope
map("n", "ff", "<Cmd>Telescope fd<CR>", opts)
map("n", "fg", "<Cmd>Telescope live_grep<CR>", opts)
map("n", "fb", "<Cmd>Telescope buffers<CR>", opts)
map("n", "fh", "<Cmd>Telescope help_tags<CR>", opts)
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

vim.keymap.set({ "n", "v" }, "=", function()
	if #require("conform").list_formatters(0) > 0 then
		return "gq"
	end
	return "="
end, { expr = true, desc = "Format with conform or fallback to treesitter indent" })

vim.keymap.set("n", "==", function()
	if #require("conform").list_formatters(0) > 0 then
		return "gqq"
	end
	return "=="
end, { expr = true, desc = "Format line with conform or fallback to treesitter indent" })

-- lsp
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)
		-- vim.keymap.set("n", "gwa", vim.lsp.buf.add_workspace_folder, opts)
		-- vim.keymap.set("n", "gwr", vim.lsp.buf.remove_workspace_folder, opts)
		-- vim.keymap.set("n", "gwl", function()
		--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		-- end, opts)
		-- vim.keymap.set("n", "gDD", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
		-- vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		-- vim.keymap.set("n", "gf", function()
		--     vim.lsp.buf.format { async = true }
		-- end, opts)
	end,
})
