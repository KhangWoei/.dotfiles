return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup()
    end,
    keys = function()
        return {
            {
                "<leader>rf",
                function() require("refactoring").select_refactor() end,
                mode = { "n", "x" },
                desc = "[R]e[f]actor Menu",
            },
            {
                "<leader>re",
                function() require("refactoring").refactor("Extract Function") end,
                mode = "x",
                desc = "[R]efactor [E]xtract Function",
            },
            {
                "<leader>rv",
                function() require("refactoring").refactor("Extract Variable") end,
                mode = "x",
                desc = "[R]efactor [V]ariable Extract",
            },
            {
                "<leader>ri",
                function() require("refactoring").refactor("Inline Variable") end,
                mode = { "n", "x" },
                desc = "[R]efactor [I]nline Variable",
            },
        }
    end,
}
