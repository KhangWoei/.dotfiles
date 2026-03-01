-- Undo tree, visualizes undo history
local undotree = {
    'mbbill/undotree',
    lazy = false,
}

undotree.keys = function()
    return {
        { "<leader>u", ":UndotreeToggle <CR>", desc = "Toggle [U]ndotree" }
    }
end

return undotree
