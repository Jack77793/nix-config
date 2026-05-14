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

for _, v in ipairs(lss) do
	vim.lsp.config(v, {
		capabilities = capabilities,
	})
	vim.lsp.enable(v)
end
