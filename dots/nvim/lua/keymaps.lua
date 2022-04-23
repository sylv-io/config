local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- disable arrows
map("n", "<Up>", "<NOP>", opts)
map("n", "<Down>", "<NOP>", opts)
map("n", "<Left>", "<NOP>", opts)
map("n", "<Right>", "<NOP>", opts)
