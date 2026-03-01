-- render-markdown.nvim

return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('render-markdown').setup({
            html  = { enabled = false },
            latex = { enabled = false },
        })
    end,
}
