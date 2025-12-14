local M = {}

local function workspace_symbols()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if not clients or vim.tbl_isempty(clients) then
    vim.notify("LSP Deactivated", vim.log.levels.WARN, { title = "Workspace Symbols" })
    return
  end

  local ok, telescope = pcall(require, 'telescope.builtin')
  if not ok then
    vim.notify("Telescope is not installed", vim.log.levels.ERROR, { title = "Workspace Symbols" })
    return
  end
  telescope.lsp_dynamic_workspace_symbols()
end

function M.setup()
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
  map('n', '<leader>fF', ':Telescope live_grep<CR>', opts)
  map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
  map('n', '<leader>d', ':Telescope buffers<CR>', opts)
  map('n', '<leader>ft', workspace_symbols, opts)

  -- Buffer navigation/management
  map('n', '<leader>[', ':bprevious<CR>', opts)
  map('n', '<leader>]', ':bnext<CR>', opts)
  map('n', '<leader>w', function()
    if vim.bo.modified then
      local choice = vim.fn.confirm("Buffer has unsaved changes. Close anyway?", "&Yes\n&No", 2)
      if choice == 1 then
        vim.cmd('bdelete!')
      end
    else
      vim.cmd('bdelete')
    end
  end, opts)

  -- Visual mode helpers
  map('v', '<', '<gv')
  map('v', '>', '>gv')
  map('v', 'J', ":m '>+1<CR>gv=gv")
  map('v', 'K', ":m '<-2<CR>gv=gv")

  -- Clear search / close popups on Esc
  map('n', '<Esc>', function()
    if vim.v.hlsearch == 1 then
      vim.cmd('nohlsearch')
      return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
      end
    end

    return '<Esc>'
  end, { expr = true, noremap = true, silent = true })
end

return M
