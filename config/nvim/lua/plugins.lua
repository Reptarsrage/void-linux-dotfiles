-- neovim package manager configuration
-- see: https://github.com/wbthomason/packer.nvim#readme
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'sainnhe/edge'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'omnisharp/omnisharp-vim'
  use 'nvim-lua/completion-nvim'

  -- Snippets
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'

  -- Fuzzy find
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' }
  }

  -- Editorconfig
  use 'editorconfig/editorconfig-vim'

  -- Syntax highliting (better)
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.install'.compilers = { "clang" }; -- needed for windows!
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { 'c_sharp', 'javascript' }, -- install additional with TSInstall
        highlight = {
          enable = true
        }
      };
    end
  }

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- status Line
  use {
   'glepnir/galaxyline.nvim',
    config = function() require'eviline' end,
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- Debugger
  use 'mfussenegger/nvim-dap'
  use {
    'nvim-telescope/telescope-dap.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('dap');
      require('dap-omnisharp').setup('D:/Downloads/Extracted/netcoredbg/netcoredbg.exe', { include_configs = true });
    end
  }

  use_rocks 'luafilesystem'
end)