-- Установка Lazy.nvim
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
  install = { colorscheme = { "habamax" } },
  checker = {
    enabled = true, 
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Основные настройки
vim.cmd("colorscheme habamax")

-- Полное отключение встроенных уведомлений о режиме
vim.opt.showmode = false
vim.opt.ruler = false

-- Базовые настройки Python
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Маппинги
-- vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.keymap.set('v', '<', '<gv')  
vim.keymap.set('v', '>', '>gv')
-- Перемещение строк в Visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")  -- Переместить выделенный блок вниз
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")  -- Переместить выделенный блок вверх
