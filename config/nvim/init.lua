-- set termguicolors
vim.o.termguicolors = true

-- load plugins
require('plugins')

local cmd = vim.cmd
local g = vim.g

-- colors
cmd "colorscheme base16-onedark"
cmd "syntax enable"
cmd "syntax on"
