return {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('illuminate').configure({
        providers = {
          'lsp',
          'regex',
        },
        delay = 100,
        min_count_to_highlight = 2  -- подсвечивать от 2+ вхождений
      })
    end,
  }
