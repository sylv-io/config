-- installs packer if needed
if require("first_load")() then
	return
end

pcall(require, "impatient")

require("plugins")
require("lsp")
require("keymaps")
require("options")
