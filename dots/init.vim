set hidden
set number
set showmatch
set smartcase
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
syntax on
filetype plugin indent on
let g:vimsyn_embed= 'lPr'
set list
set listchars=tab:>-,nbsp:_,trail:•,extends:>,precedes:<
set cc=80
highlight ColorColumn ctermbg=black
" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
autocmd VimResized * wincmd =
set path=.,,**
" disable arrows
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
" move between windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
" NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>
" FZF
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :FZF ~<cr>

lua << EOF
-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
  if packer_bootstrap then
    require('packer').sync()
  end
end)

if packer_bootstrap then
  -- reload config
  packer_bootstrap = false
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
end
EOF
