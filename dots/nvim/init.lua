pcall(require, "impatient")

Init = not pcall(require, "packer")
require("plugins")

if Init then
	-- reload configuration
	vim.cmd [[
		autocmd User PackerComplete source $MYVIMRC
	]]
	return
end

require("config")
require("keymaps")
require("options")
