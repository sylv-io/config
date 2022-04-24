pcall(require, "impatient")

-- installs packer if needed
if require("first_load")() then
	return
end

require("plugins")
require("config")
require("keymaps")
require("options")
