return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	-- Improve startup time
	use("lewis6991/impatient.nvim")
	-- LSP
	use("neovim/nvim-lspconfig")
	-- Autocompletion
	use("hrsh7th/nvim-cmp")
	-- LSP source for nvim-cmp
	use("hrsh7th/cmp-nvim-lsp")
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
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		config = function()
			require("telescope").load_extension("fzf")
		end,
		requires = { { "nvim-telescope/telescope.nvim" } },
		run = "make",
	})
end)
