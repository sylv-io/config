vim.cmd([[
filetype plugin indent on
highlight ColorColumn ctermbg=black
" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
autocmd VimResized * wincmd =
]])

---- settings
-- Enable syntax highlighting
vim.o.syntax = "on"
vim.o.list = true
-- Number of spaces that a <Tab> in the file counts for
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.listchars = "tab:>-,nbsp:_,trail:•,extends:>,precedes:<"
vim.o.cc = "80";

-- Enable wrap
vim.o.wrap = true
-- Make line numbers default
vim.wo.number = true
-- Show cursor line and column in the status line
vim.o.ruler = true
-- Number of command-lines that are remembered
vim.o.history = 10000
-- Show (partial) command in status line
vim.o.showcmd = false

-- Wrap long lines at a blank
vim.o.linebreak = true
-- Enable break indent
vim.o.breakindent = true
-- Take indent for new line from previous line
vim.o.autoindent = true
vim.o.smartindent = true

-- Enable highlight on search
vim.o.hlsearch = true
-- highlight match while typing search pattern
vim.o.incsearch = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Briefly jump to matching bracket if insert one
vim.o.showmatch = true
-- Hide show current mode on status line
vim.o.showmode = false
-- Ignore case when completing file names and directories.
vim.o.wildignorecase = true

-- Use menu for command line completion
vim.o.wildmenu = true
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- Disable intro message
vim.opt.shortmess:append("I")
-- Disable ins-completion-menu messages
vim.opt.shortmess:append("c")

-- Do not save when switching buffers
vim.o.hidden = true
-- Autom. read file when changed outside of Vim
vim.o.autoread = true

-- Do not source the default filetype.vim
vim.g.did_load_filetypes = 1
-- Disable python2 provider
vim.g.loaded_python_provider = 0

--  Maximum height of the popup menu
vim.o.pumheight = 15
-- Minimum nr. of lines above and below cursor
vim.o.scrolloff = 5 -- could be 1
vim.o.sidescrolloff = 5
-- vim.o.display = 'lastline'

-- Folding
vim.o.foldenable = false
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- Timeout on leaderkey
vim.o.ttimeout = true
vim.o.ttimeoutlen = 5
-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
-- Asyncrun automatically open quickfix window
vim.g.asyncrun_open = 6

---- keymaps
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-- disable arrows
map("n", "<Up>", "<NOP>", opts)
map("n", "<Down>", "<NOP>", opts)
map("n", "<Left>", "<NOP>", opts)
map("n", "<Right>", "<NOP>", opts)
-- move between windows
map("n", "<C-J>", "<C-W>j", opts)
map("n", "<C-K>", "<C-W>k", opts)
map("n", "<C-L>", "<C-W>l", opts)
map("n", "<C-H>", "<C-W>h", opts)
-- NERDTree
map("n", "<leader>t", ":NERDTreeToggle<CR>", opts)
-- FZF
map("n", "<leader>f", ":FZF<CR>", opts)
map("n", "<leader>F", ":FZF ~<CR>", opts)

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- install plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- UI
  use 'preservim/nerdtree'
  -- theme
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  -- POSIX shell
  use 'itspriddle/vim-shellcheck'
  -- text linting
  use 'editorconfig/editorconfig-vim'
  -- Git
  use 'tpope/vim-fugitive'
  -- LSP
  use 'neovim/nvim-lspconfig'
  -- complete
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- vsnip
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  if Packer_bootstrap then
    require('packer').sync()
  end
end)

if Packer_bootstrap then
  -- reload config
  Packer_bootstrap = false
  vim.cmd [[
    autocmd User PackerComplete source $MYVIMRC
  ]]
else
  -- load libs
  local nvim_lsp = require('lspconfig')
  local cmp = require('cmp')

  -- custom lsp keymaps
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    local opts = { noremap=true, silent=true }
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- init cmp
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    },
  })

  -- init lsp servers
  local servers = { 'als', 'bashls', 'cmake', 'dockerls', 'dotls', 'gopls', 'html', 'jsonls', 'texlab',
  'rnix', 'psalm', 'pyright', 'rls', 'taplo', 'tsserver', 'vimls', 'lemminx', 'yamlls' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
  end

  -- TODO: prevent default boilerplate
  -- custom lsp setup for clangd
  nvim_lsp.clangd.setup{
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    cmd={"clangd", "-j=4", "-completion-style=detailed", "-background-index", "-all-scopes-completion", "--suggest-missing-includes"}
  }
  nvim_lsp.sumneko_lua.setup{
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  }
end
