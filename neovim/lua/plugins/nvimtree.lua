return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
        view = {
            side="left",
        },
        filters = {
            dotfiles = false, -- Показывать скрытые файлы
            git_ignored = false, -- Показывать файлы, игнорируемые Git
        },
        renderer = {
            icons = {
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
              },
            },
        },
    }
  end,
}
