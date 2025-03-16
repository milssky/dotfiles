-- Установка Lazy.nvim!
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

-- Базовые настройки Neovim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Загрузка плагинов
require("lazy").setup("plugins", {
  install = { colorscheme = { "nord" } },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Основные настройки
-- vim.cmd("colorscheme habamax")
-- Полное отключение встроенных уведомлений о режиме
vim.opt.showmode = false
vim.opt.ruler = false
vim.cmd("colorscheme github_dark")

-- Базовые настройки Python
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Маппинги
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>F', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>")
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
vim.keymap.set('n', '<leader>d', function()
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
