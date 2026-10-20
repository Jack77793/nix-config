require("conform").setup({
	formatters_by_ft = {
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		nix = { "nixfmt" },
		python = { "isort", "black" },
		rust = { "rustfmt" },
		typescript = { "prettier" },
		vue = { "prettier" },
		yaml = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
