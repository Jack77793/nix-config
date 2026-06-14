require("cmp").setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = require("cmp").mapping.preset.insert({
		["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
		["<C-f>"] = require("cmp").mapping.scroll_docs(4),
		["<None>"] = require("cmp").mapping.complete(),
		["<C-e>"] = require("cmp").mapping.abort(),
		["<CR>"] = require("cmp").mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<C-k>"] = require("cmp").mapping.select_prev_item(),
		["<C-j>"] = require("cmp").mapping.select_next_item(),
	}),
	sources = require("cmp").config.sources({
		-- @extended_sources@
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "treesitter" },
		{ name = "buffer" },
	}),
	window = {
		completion = {
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
			col_offset = -3,
			side_padding = 0,
		},
	},
	formatting = {
		fields = { "icon", "abbr", "menu", "kind" },
		format = function(entry, vim_item)
			local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
			kind.icon = " " .. (kind.icon or "") .. "  "
			kind.kind = " (" .. (kind.kind or "") .. ") "

			return kind
		end,
	},
})

-- autopair settings
require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
