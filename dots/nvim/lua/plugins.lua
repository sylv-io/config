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
end)
