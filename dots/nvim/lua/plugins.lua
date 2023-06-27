local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
  end
  Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	-- Improve startup time
	use("lewis6991/impatient.nvim")
	-- Treesitter
	use("nvim-treesitter/nvim-treesitter")
	-- LSP
	use("neovim/nvim-lspconfig")
	-- nvim-lsp progress UI
	use("j-hui/fidget.nvim")
	-- LSP source for nvim-cmp
	use("hrsh7th/cmp-nvim-lsp")
	-- Completion & Snippets
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	-- Autocompletion
	use("hrsh7th/nvim-cmp")
	-- Java
	use("mfussenegger/nvim-jdtls")
	-- Go development
	use("fatih/vim-go")
	-- Display popup with possible keybindings
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	})
	-- Lazygit in Neovim
	use("kdheepak/lazygit.nvim")
	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})
	-- Fuzzy filtering
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup()
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})
	-- improve rust lspconfig
	use({
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup()
		end,
	})
	use("nvim-lua/plenary.nvim")
	use("mfussenegger/nvim-dap")
	-- Automatically set up your configuration after cloning packer.nvim
	if Packer_bootstrap then
		require('packer').sync()
	end
end)
