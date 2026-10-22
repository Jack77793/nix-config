local lss = { "clangd", "lua_ls", "pylsp", "bashls", "rust_analyzer", "nixd" }
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				preloadFileSize = 10000,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})

vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				autopep8 = { enabled = false },
				yapf = { enabled = false },
				pycodestyle = { enabled = false },
				pyflakes = { enabled = false },
				mccabe = { enabled = false },
				flake8 = { enabled = true },
				rope = { enabled = true },
			},
			configurationSources = { "flake8" },
		},
	},
})

for _, v in ipairs(lss) do
	vim.lsp.config(v, {
		capabilities = capabilities,
	})
	vim.lsp.enable(v)
end
