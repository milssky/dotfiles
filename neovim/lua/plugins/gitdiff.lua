return {
  'sindrets/diffview.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { '<leader>Dv', ':DiffviewOpen<CR>', desc = 'Open Diffview' },
    { '<leader>Dc', ':DiffviewClose<CR>', desc = 'Close Diffview' },
    { '<leader>Dh', ':DiffviewFileHistory<CR>', desc = 'File History' }
  },
  config = function()
    require('diffview').setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      use_icons = true,
      show_help_hints = true,
      watch_view = {
        layout = "lean_left",
        win_options = {
          winblend = 0,
        },
      },
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      }
    })
  end
}
