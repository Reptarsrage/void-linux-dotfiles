-- neovim configuration entry file
-- see: https://github.com/nanotee/nvim-lua-guide

-- NOTE: Windows requires the following:
-- choco install neovim --pre
-- choco install omnisharp llvm fd

-- load Packer plugins
require('plugins')

local o = vim.o
local wo = vim.wo
local g = vim.g
local cmd = vim.cmd
local api = vim.api
local fn = vim.fn

-- set leader
g.mapleader = ' '
g.maplocalleader = ' '

-- set theme
g.edge_style = 'aura'
g.edge_enable_italic = 1
g.edge_disable_italic_comment = 1
cmd 'colorscheme edge'
cmd 'syntax enable'
cmd 'filetype plugin indent on'

-- initialize Omnisharp
-- see: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#omnisharp
local lspconfig = require('lspconfig')
local pid = fn.getpid()
local omnisharp_bin = 'C:/ProgramData/chocolatey/bin/OmniSharp.exe'
local capabilities = vim.lsp.protocol.make_client_capabilities();
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.omnisharp.setup{
  capabilities = capabilities;
  root_dir = lspconfig.util.root_pattern('*.sln', '*.csproj', '.git');
  on_attach = require('on_attach').on_attach;
  cmd = { omnisharp_bin, '--languageserver' , '--hostPID', tostring(pid) };
}

local opts = { noremap=true, silent=true }

-- find files using Telescope command-line sugar
api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
api.nvim_set_keymap('n', '<leader>fl', '<cmd>Telescope git_files<CR>', opts)

-- file tree mappings
api.nvim_set_keymap('n', '<leader>tt', '<cmd>NvimTreeToggle<CR>', opts)
api.nvim_set_keymap('n', '<leader>tr', '<cmd>NvimTreeRefresh<CR>', opts)
api.nvim_set_keymap('n', '<leader>tn', '<cmd>NvimTreeFindFile<CR>', opts)

-- debugger mappings
api.nvim_set_keymap('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>", opts)
api.nvim_set_keymap('n', '<leader>dd', "<cmd>lua require'dap'.continue()<CR>", opts)
api.nvim_set_keymap('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>", opts)
api.nvim_set_keymap('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>", opts)
api.nvim_set_keymap('n', '<S-F11>', "<cmd>lua require'dap'.step_out()<CR>", opts)
api.nvim_set_keymap('n', '<C-S-F5>', "<cmd>lua require'dap'.restart()<CR>", opts)
api.nvim_set_keymap('n', '<S-F5>', "<cmd>lua require'dap'.disconnect()<CR>", opts)
api.nvim_set_keymap('n', '<S-F9>', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
-- TODO: add non fn-button related shortcuts

-- debugger options
require('dap')
fn.sign_define('DapBreakpoint', {text='B', texthl='', linehl='', numhl=''})
fn.sign_define('DapLogPoint', {text='L', texthl='', linehl='', numhl=''})
fn.sign_define('DapStopped', {text='→', texthl='', linehl='debugPC', numhl=''})

-- enable loading of vscode launch.json settings files
require('dap.ext.vscode').load_launchjs()

-- debugger telescope integration
api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require'telescope'.extensions.dap.commands{}<CR>", opts)
api.nvim_set_keymap('n', '<leader>dC', "<cmd>lua require'telescope'.extensions.dap.configurations{}<CR>", opts)
api.nvim_set_keymap('n', '<leader>db', "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<CR>", opts)
api.nvim_set_keymap('n', '<leader>dv', "<cmd>lua require'telescope'.extensions.dap.variables{}<CR>", opts)

-- nvim-tree options
g.nvim_tree_side = 'right'
g.nvim_tree_gitignore = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1
}

-- a collection of settings from throught the years
o.termguicolors  = true -- truecolours for better experience
o.autoindent     = true -- enable autoindent
o.backup         = false -- disable backup
o.writebackup    = false -- disable backup
o.backupcopy     = 'yes' -- fix weirdness for stuff that replaces the entire file when hot reloading
o.swapfile       = false -- disable swapfile
o.autowrite      = true -- autowrite buffer when it's not focused
o.hidden         = false -- keep hidden buffers
o.hlsearch       = true -- don't highlight matching search
o.showmode       = false -- don't show mode
o.smartcase      = true -- improve searching using '/'
o.ignorecase     = true -- case insensitive on search
o.lazyredraw     = true -- lazyredraw to make macro faster
o.smarttab       = true -- make tab behaviour smarter
o.smartindent    = true -- smarter indentation
o.completeopt    = 'menu,menuone,noselect,noinsert' -- better completion
o.shortmess      = o.shortmess .. 'c' -- avoid showing message extra message when using completion
o.encoding       = 'UTF-8' -- set encoding
o.inccommand     = 'split' -- incrementally show result of command
o.mouse          = 'a' -- enable mouse support
o.laststatus     = 2 -- always enable statusline
o.pumheight      = 10 -- limit completion items
o.re             = 0 -- set regexp engine to auto
o.sidescroll     = 2 -- make scrolling better
o.timeoutlen     = 400 -- faster timeout wait time
o.updatetime     = 100 -- set faster update time
o.incsearch      = true -- incremental search that shows partial matches
o.ruler          = true -- always show cursor position
o.wildmenu       = true -- display command line’s tab complete options as a menu
o.tabpagemax     = 50 -- maximum number of tab pages that can be opened from the command line
o.errorbells     = false -- disable beep on errors.
o.visualbell     = true -- flash the screen instead of beeping on errors
o.title          = true -- set the window’s title, reflecting the file currently being edited
o.autoread       = true --  automatically re-read files if unmodified inside Vim
o.backspace      = 'indent,eol,start' -- allow backspacing over indention, line breaks and insertion start
o.confirm        = true -- display a confirmation dialog when closing an unsaved file
o.history        = 1000 -- increase the undo limit
o.autochdir      = true -- automatically change directory (might be useful for LSP)
o.background     = 'dark' -- use colors that suit a dark background
o.splitbelow     = true -- split below instead of above
o.splitright     = true -- split right instead of left
o.startofline    = false -- don't go to the start of the line when moving to another file
o.expandtab      = true -- use spaces instead of tabs (should be overridden by editorconfig)
o.shiftwidth     = 4 -- set indentation width (should be overridden by editorconfig)
o.tabstop        = 4 -- tabsize (should be overridden by editorconfig)
o.softtabstop    = 4 -- tabsize (should be overridden by editorconfig)
o.cmdheight      = 1 -- height of command line

wo.cursorline     = true -- enable cursorline
wo.list           = true -- display listchars
wo.listchars      = 'space:·,tab:▷ ,trail:·,extends:◣,precedes:◢,nbsp:○' -- set listchars
wo.wrap           = true -- wrap lines
wo.fillchars      = 'vert:|,eob: ' -- make vertical split sign better
wo.signcolumn     = 'yes' -- enable sign column all the time, 4 column
wo.scrolloff      = 2 -- make scrolling better
wo.sidescrolloff  = 15 -- make scrolling better
wo.linebreak      = true -- avoid wrapping a line in the middle of a word
wo.number         = true -- show line numbers on the sidebar
wo.foldnestmax    = 3 -- only fold up to three nested levels
wo.foldenable     = false -- disable folding by default
wo.foldmethod     = 'marker' -- foldmethod using marker