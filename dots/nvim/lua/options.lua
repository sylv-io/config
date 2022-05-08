-- Incremental live completion
vim.o.inccommand = "nosplit"
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- Enable highlight on search
vim.o.hlsearch = true
-- highlight match while typing search pattern
vim.o.incsearch = true
-- Make line numbers default
vim.wo.number = true
-- Do not save when switching buffers
vim.o.hidden = true
-- Enable break indent
vim.o.breakindent = true
-- Use swapfiles
vim.o.swapfile = true
-- Save undo history
vim.o.undofile = true
vim.o.undolevels = 1000
-- Faster scrolling
vim.o.lazyredraw = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
-- Decrease redraw time
vim.o.redrawtime = 100
-- Disable intro message
vim.opt.shortmess:append("I")
-- Disable ins-completion-menu messages
vim.opt.shortmess:append("c")
-- Take indent for new line from previous line
vim.o.autoindent = true
vim.o.smartindent = true
-- Number of command-lines that are remembered
vim.o.history = 10000
-- Use menu for command line completion
vim.o.wildmenu = true
-- Enable wrap
vim.o.wrap = true
-- Wrap long lines at a blank
vim.o.linebreak = true
-- Autom. read file when changed outside of Vim
vim.o.autoread = true
-- Show cursor line and column in the status line
vim.o.ruler = true
-- Show absolute line number in front of each line
vim.o.relativenumber = false
-- Ignore case when completing file names and directories.
vim.o.wildignorecase = true
-- Show tabs and trailing spaces
vim.o.list = true
vim.o.listchars = "tab:>-,nbsp:_,trail:•,extends:>,precedes:<"
-- Neovide config
vim.g.neovide_cursor_animation_length = 0.0
vim.g.neovide_cursor_trail_length = 0.0
-- colorscheme
vim.cmd('colorscheme industry')
-- transparent background
vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
