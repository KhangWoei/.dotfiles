-- lualine.lua
-- Add indentation guides even on blank lines

local lualine = {
	'nvim-lualine/lualine.nvim',
}

lualine.config = function()
	-- See `:help lualine.txt`
	require('lualine').setup({
		options = {
			icons_enabled = true,
			theme = 'powerline_dark',
			component_separators = '|',
			section_separators = '',
		},
	})
end

return lualine
