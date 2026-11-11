-- encoding
vim.g.encoding = "UTF-8"
vim.opt.fileencoding = "utf-8"
-- keep 8 lines when moving cursor by j and k
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = false
-- highlight cursorline
vim.opt.cursorline = true
-- show signcolumn
vim.opt.signcolumn = "yes"
-- diagnostics
vim.diagnostic.config({
	virtual_text = true,
})
-- tabulator settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.showtabline = 2
-- searching settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- cmdline height
vim.opt.cmdheight = 1
-- autoreload
vim.opt.autoread = true
-- disable wrapping
vim.opt.wrap = false
-- mouse supporting
vim.opt.mouse = "a"
-- disable backup
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
-- new split window appears from blow and right
vim.opt.splitbelow = true
vim.opt.splitright = true
-- unvisible character display
vim.opt.list = true
vim.opt.listchars:append("space:･")
vim.opt.listchars:append("eol:↲")
-- completing enhancement
vim.opt.wildmenu = true
-- clipboard
vim.opt.clipboard:prepend("unnamedplus")
-- decoration
vim.opt.background = "dark"
vim.opt.termguicolors = true

if vim.g.neovide then
	vim.o.guifont = "Sarasa Fixed SC:h16"
	vim.g.neovide_scroll_animation_length = 0.1
	vim.g.neovide_theme = "bg_color"
	vim.g.neovide_cursor_short_animation_length = 0.01
	vim.g.neovide_cursor_vfx_mode = "pixiedust"
end
