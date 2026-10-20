vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"c",
		"cpp",
		"css",
		"html",
		"ini",
		"json",
		"jsonc",
		"latex",
		"lua",
		"make",
		"markdown",
		"nix",
		"python",
		"rust",
		"toml",
		"vim",
		"xml",
		"yaml",
	},
	callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		-- indentation, provided by nvim-treesitter
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- do not fold by default
vim.wo.foldlevel = 99
