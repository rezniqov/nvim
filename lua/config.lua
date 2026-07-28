local opt = vim.opt

vim.g.mapleader = " "

opt.nu = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.listchars = "tab: ,multispace:|   ,eol:󰌑"
opt.winborder = "rounded"
opt.clipboard = "unnamedplus"
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.laststatus = 3
opt.cmdheight = 0
vim.o.scrolloff = 10

-- backup and swap
opt.swapfile = false
opt.backup = false

-- scrool
opt.smoothscroll = true
