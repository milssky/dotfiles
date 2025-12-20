return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local function set_tree_bg()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        local float_border = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
        local border_fg = float_border.fg or normal.fg

        if normal.bg then
            vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = normal.bg })
            vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = normal.bg })
            vim.api.nvim_set_hl(0, "NvimTreeNormalFloat", { bg = normal.bg })
            vim.api.nvim_set_hl(0, "NvimTreeNormalFloatBorder", { bg = normal.bg, fg = border_fg })
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = normal.bg, bg = normal.bg })
        else
            vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
            vim.api.nvim_set_hl(0, "NvimTreeNormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "NvimTreeNormalFloatBorder", { bg = "none", fg = border_fg })
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
        end
    end

    require("nvim-tree").setup {
        view = {
            width = 80,
            number = false,
            relativenumber = false,
            signcolumn = "no",
            float = {
                enable = true,
                open_win_config = function()
                    local width = 80
                    local height = 30
                    return {
                        relative = "editor",
                        border = "rounded",
                        width = width,
                        height = height,
                        row = (vim.o.lines - height) / 2,
                        col = (vim.o.columns - width) / 2,
                    }
                end,
            },
        },
        filters = {
            dotfiles = false,
            git_ignored = false,
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

    set_tree_bg()
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_tree_bg,
    })
  end,
}
