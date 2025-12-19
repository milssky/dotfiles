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
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
require("keymaps").setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = false,         -- Показывает значки на полях
  underline = true,     -- Подчёркивает проблемные места
  update_in_insert = false,  -- Не обновлять диагностику в режиме вставки
  severity_sort = true, -- Сортировать ошибки по серьёзности
})
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focusable=false})]]
