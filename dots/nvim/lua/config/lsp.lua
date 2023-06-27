-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
  lua_ls = {
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

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "buffer"},
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
