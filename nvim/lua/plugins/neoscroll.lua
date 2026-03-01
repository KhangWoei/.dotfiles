-- neoscroll

local neoscroll = {
    "karb94/neoscroll.nvim"
}

neoscroll.config = function()
    require('neoscroll').setup({
        mappings = {
            ['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '250' } },
            ['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '250' } }
        }
    })
end

return neoscroll
