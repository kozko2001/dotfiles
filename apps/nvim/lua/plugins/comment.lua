return {
  {
    'numToStr/Comment.nvim',
    config = function() 
      require('Comment').setup({
        mappings = {
          extra = false,
        }
      })
    end
  }
}
