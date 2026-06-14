local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- telescope
map("n", "ff", "<Cmd>Telescope fd<CR>", opts)
map("n", "fg", "<Cmd>Telescope live_grep<CR>", opts)
map("n", "fb", "<Cmd>Telescope buffers<CR>", opts)
map("n", "fh", "<Cmd>Telescope help_tags<CR>", opts)

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
