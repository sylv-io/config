local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
  end
  Packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

return require("packer").startup(function()
  -- Packer can manage itself
  use("wbthomason/packer.nvim")
  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true
        },
        indent = {
          enable = true,
        },
      }
    end,
  }
  --  auto indent
  use("Darazaki/indent-o-matic")
  use {
    "Darazaki/indent-o-matic",
    config = function()
      require('indent-o-matic').setup {
        -- Number of lines without indentation before giving up (use -1 for infinite)
        max_lines = 2048,
        -- Space indentations that should be detected
        standard_widths = { 2, 4, 8 },
        -- Skip multi-line comments and strings (more accurate detection but less performant)
        skip_multiline = true,
      }
    end
  }
  -- LSP
  use {
    "neovim/nvim-lspconfig",
    requires = {
      -- nvim-lsp progress UI
      { "j-hui/fidget.nvim", branch = "legacy" },
      -- improve rust
      { "simrat39/rust-tools.nvim" },
    }
  }
  -- DAP
  --use{
  --  "mfussenegger/nvim-dap",
  --  config = function()
  --    require("dapui").setup()
  --    require('dap-go').setup {
  --      -- Additional dap configurations can be added.
  --      -- dap_configurations accepts a list of tables where each entry
  --      -- represents a dap configuration. For more details do:
  --      -- :help dap-configuration
  --      dap_configurations = {
  --        {
  --          -- Must be "go" or it will be ignored by the plugin
  --          type = "go",
  --          name = "Attach remote",
  --          mode = "remote",
  --          request = "attach",
  --        },
  --      },
  --      -- delve configurations
  --      delve = {
  --        -- the path to the executable dlv which will be used for debugging.
  --        -- by default, this is the "dlv" executable on your PATH.
  --        path = "dlv",
  --        -- time to wait for delve to initialize the debug session.
  --        -- default to 20 seconds
  --        initialize_timeout_sec = 20,
  --        -- a string that defines the port to start delve debugger.
  --        -- default to string "${port}" which instructs nvim-dap
  --        -- to start the process in a random available port
  --        port = "${port}",
  --        -- additional args to pass to dlv
  --        args = {}
  --      },
  --    }
  --  end,
  --  requires = {
  --    { "rcarriga/nvim-dap-ui" },
  --    { "mfussenegger/nvim-dap" },
  --    { "leoluz/nvim-dap-go" },
  --  }
  --}
  -- Autocompletion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      -- LSP source for nvim-cmp
      { "hrsh7th/cmp-nvim-lsp" },
      -- Completion & Snippets
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
    }
  }
  -- Java
  use("mfussenegger/nvim-jdtls")
  -- Go development
  use("fatih/vim-go")
  -- Display popup with possible keybindings
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  }
  -- Lazygit in Neovim
  use("kdheepak/lazygit.nvim")
  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  }
  -- Fuzzy filtering
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = { ".cache/*", ".git/*", ".local/*", ".rustup/*", "node_modules/*" },
        },
        pickers = {
          find_files = {
            hidden = true;
          }
        }
      }
    end,
    requires = { "nvim-lua/plenary.nvim" },
  }
  -- Automatically set up your configuration after cloning packer.nvim
  if Packer_bootstrap then
    require('packer').sync()
  end
end)
