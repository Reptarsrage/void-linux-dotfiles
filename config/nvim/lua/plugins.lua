return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  -- Themes
  use 'chriskempson/base16-vim'
  
  -- Color highlights
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  }

  -- File Explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require('nvim-tree-config')
    end
  }

  -- Git decoration
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Status line
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function()
      require('statusline')
    end,
    requires = {
      'kyazdani42/nvim-web-devicons'
    }
  }

  -- Nested syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = "maintained",
	ignore_install = { },
	highlight = {
          enable = true,
	  disable = { },
        }
      }
    end
  }

  -- Autocomplete
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = true;
        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          vsnip = true;
        };
      }
    end
  }
  
  -- Auto close pairs and html tags
  use 'windwp/nvim-autopairs'
  use {
    'alvan/vim-closetag',
    config = function()
      require('closetag-config')
    end
  }

  -- Pop-ups
  use {
    'nvim-lua/popup.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  -- Language server configs
  use 'onsails/lspkind-nvim'
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').gopls.setup{}
    end
  }
end)
