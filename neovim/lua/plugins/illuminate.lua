return {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        delay = 0,
        min_count_to_highlight = 2  -- подсвечивать от 2+ вхождений
      })
    end,
    lazy = false,
  }