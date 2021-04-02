local g = vim.g
local api = vim.api

-- Options
g.nvim_tree_side = 'right' 
g.nvim_tree_width = 40 
g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' } 
g.nvim_tree_gitignore = 1 
g.nvim_tree_auto_open = 1 
g.nvim_tree_auto_close = 1 
g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
g.nvim_tree_quit_on_open = 1 
g.nvim_tree_follow = 1 
g.nvim_tree_indent_markers = 1 
g.nvim_tree_hide_dotfiles = 1 
g.nvim_tree_git_hl = 1 
g.nvim_tree_root_folder_modifier = ':~' 
g.nvim_tree_tab_open = 1 
g.nvim_tree_width_allow_resize  = 1 
g.nvim_tree_disable_netrw = 0 
g.nvim_tree_hijack_netrw = 0 
g.nvim_tree_add_trailing = 1 
g.nvim_tree_group_empty = 1 
g.nvim_tree_show_icons = { 
  git = 1, 
  folders = 1, 
  files = 1 
}

-- Icons
g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = ""
  },
  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
    symlink_open = ""
   }
}

-- Keymappings
api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>n", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", { noremap = true, silent = true })
