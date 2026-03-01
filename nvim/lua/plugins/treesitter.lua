-- treesitter.lua
local treesitter = {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
}

treesitter.config = function()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            'c_sharp',
            'go',
            'lua',
            'python',
            'tsx',
            'javascript',
            'typescript',
            'vimdoc',
            'vim',
            'bash',
        },

        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
    }
end

return treesitter

