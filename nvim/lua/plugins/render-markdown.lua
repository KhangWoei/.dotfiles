-- render-markdown.nvim

local render_markdown = {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
}

render_markdown.config = function()
    require('render-markdown').setup({
        html  = { enabled = false },
        latex = { enabled = false },
    })
end

return render_markdown
