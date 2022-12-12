-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lspconfig = require('lspconfig')
local servers = {
  als = true,
  asm_lsp = {
    filetypes = {
      "asm",
      "asm16",
      "vmasm",
      "nasm",
      "nasmb",
    },
  },
  bashls = true,
  clangd = {
    cmd = {
      "clangd",
      "-j=4",
      "-completion-style=detailed",
      "-background-index",
      "-all-scopes-completion",
      "--suggest-missing-includes"
    },
  },
  cmake = true,
  dockerls = true,
  dotls = true,
  golangci_lint_ls = true,
  gopls = {
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
  },
  html = true,
  jdtls = true,
  jsonls = true,
  perlpls = true,
  psalm = true,
  --pylsp = {
  --  plugins = {
  --    pycodestyle = {
  --      ignore = {'E501', 'E261'},
  --      maxLineLength = 100
  --    }
  --  }
  --},
  pyright = true,
  rust_analyzer = true,
  rnix = true,
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'use' }
        }
      }
    },
  },
  taplo = true,
  texlab = true,
  tsserver = true,
  vimls = true,
  vuels = true,
  --yamlls = true,
}

for name, cfg in pairs(servers) do
  -- default server config
  local def = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if type(cfg) == 'table' then
    -- merge server specific config
    for k,v in pairs(cfg) do def[k] = v end
  elseif cfg == false then
    -- skip this server
    return
  end

  lspconfig[name].setup(def)
end

-- nvim-lsp progress UI
require"fidget".setup{}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer"},
    { name = "cmdline"},
  },
}

cmp.setup.cmdline("/", {
  sources = cmp.config.sources({
    { name = "buffer" }
  }),
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
  { name = "path" },
  { name = "cmdline", keyword_length = 3 },
  }),
})
