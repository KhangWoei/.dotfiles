-- comment.lua
-- "gcc" to comment visual regions/lines

local comment = {
  'numToStr/Comment.nvim',
}

comment.config = function()
  require('Comment').setup({})
end

return comment
