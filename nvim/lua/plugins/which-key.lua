-- which-key.lua
-- Useful plugin to show you pending keybinds.

local which_key = {
  'folke/which-key.nvim',
}

which_key.config = function()
  require('which-key').setup({})
end

return which_key
