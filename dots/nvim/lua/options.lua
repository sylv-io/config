local set = vim.opt -- set options
-- Incremental live completion
set.inccommand = "nosplit"
-- Set completeopt to have a better completion experience
set.completeopt = "menuone,noinsert,noselect"
-- Enable highlight on search
set.hlsearch = true
-- Enable GUI colors in the terminal
vim.o.termguicolors = true
-- highlight match while typing search pattern
set.incsearch = true
-- Make line numbers default
vim.wo.number = true
-- Do not save when switching buffers
set.hidden = true
-- Enable break indent
set.breakindent = true
-- Use swapfiles
set.swapfile = true
-- Save undo history
set.undofile = true
set.undolevels = 1000
-- Faster scrolling
set.lazyredraw = true
-- Case insensitive searching UNLESS /C or capital in search
set.ignorecase = true
set.smartcase = true
-- Decrease update time
set.updatetime = 250
vim.wo.signcolumn = "yes"
-- Disable intro message
set.shortmess:append("I")
-- Disable ins-completion-menu messages
set.shortmess:append("c")
-- Disable mouse integration
set.mouse = ""
-- Take indent for new line from previous line
set.autoindent = true
set.smartindent = true
-- Number of command-lines that are remembered
set.history = 10000
-- Use menu for command line completion
set.wildmenu = true
-- Enable wrap
set.wrap = true
-- Wrap long lines at a blank
set.linebreak = true
-- Autom. read file when changed outside of Vim
set.autoread = true
-- Show cursor line and column in the status line
set.ruler = true
-- Show absolute line number in front of each line
set.relativenumber = false
-- Ignore case when completing file names and directories.
set.wildignorecase = true
-- Show tabs and trailing spaces
set.list = true
set.listchars = "tab:>-,nbsp:_,trail:•,extends:>,precedes:<"
-- Neovide config
vim.g.neovide_cursor_animation_length = 0.0
vim.g.neovide_cursor_trail_length = 0.0
-- transparent background
vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
-- readable pmenu
vim.cmd("hi Pmenu ctermfg=white guifg=white ctermbg=black guibg=black")
-- set default tab spacing
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
-- Set file-specific indentation settings for code
vim.cmd("autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab")
vim.cmd("autocmd FileType nix setlocal tabstop=2 shiftwidth=2 expandtab")

-- Ansible
vim.filetype.add({
  extension = {
    yml = 'yaml.ansible'
  }
})
