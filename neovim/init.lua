local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup("plugins", {
  install = { colorscheme = { "gruvbox" } },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

vim.opt.showmode = false
vim.opt.ruler = false
vim.cmd("colorscheme gruvbox")

-- Базовые настройки Python
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>fF', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>d', ':Telescope buffers<CR>', {noremap = true, silent = true})

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

vim.keymap.set('n', '<leader>ft', workspace_symbols, { noremap = true, silent = true })
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '<Esc>', function()
  -- Если есть подсвеченный поиск - убираем
  if vim.v.hlsearch == 1 then
    vim.cmd('nohlsearch')
    return
  end
  
  -- Закрытие всплывающих окон (например, от LSP)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
  
  return '<Esc>'
end, { expr = true, noremap = true, silent = true })

-- Перемещение по буферам
vim.keymap.set('n', '<leader>[', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>]', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', function()
  -- Проверяем, есть ли несохраненные изменения
  if vim.bo.modified then
    local choice = vim.fn.confirm("Buffer has unsaved changes. Close anyway?", "&Yes\n&No", 2)
    if choice == 1 then
      vim.cmd('bdelete!')
    end
  else
    vim.cmd('bdelete')
  end
end, { noremap = true, silent = true })

-- Перемещение строк в Visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")  -- Переместить выделенный блок вниз
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")  -- Переместить выделенный блок вверх


vim.diagnostic.config({
  virtual_text = true,
  signs = true,         -- Показывает значки на полях
  underline = true,     -- Подчёркивает проблемные места
  update_in_insert = false,  -- Не обновлять диагностику в режиме вставки
  severity_sort = true, -- Сортировать ошибки по серьёзности
})
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focusable=false})]]
