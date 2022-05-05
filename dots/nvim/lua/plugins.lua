return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	-- Improve startup time
	use("lewis6991/impatient.nvim")
	-- Treesitter
	use("nvim-treesitter/nvim-treesitter")
	-- LSP
	use({
		"neovim/nvim-lspconfig",
		after = { "nvim-cmp"},
	})
	-- LSP source for nvim-cmp
	use("hrsh7th/cmp-nvim-lsp")
	-- Completion & Snippets
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	-- Autocompletion
	use({
		"hrsh7th/nvim-cmp",
		after = {
			"LuaSnip",
			"cmp_luasnip",
			"cmp-nvim-lua",
			"cmp-nvim-lsp",
			"cmp-buffer",
			"cmp-path",
			"cmp-cmdline",
		},
	})
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
end)
