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
vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/venv/bin/python")
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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
vim.opt.cmdheight = 0
vim.cmd("colorscheme gruvbox")

-- Базовые настройки Python
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes:1"
vim.opt.foldcolumn = "0"

_G.dotfiles_statuscolumn = function()
  if vim.v.virtnum ~= 0 then
    return ""
  end

  if vim.v.lnum == vim.fn.line(".") then
    return vim.fn.virtcol(".")
  end

  return vim.v.lnum
end

-- Keep the sign column, right-align the value, and show the cursor's virtual
-- column instead of the line number on the current line.
vim.opt.statuscolumn = "%s%=%{v:lua.dotfiles_statuscolumn()} "

local statuscolumn_group = vim.api.nvim_create_augroup("CursorStatuscolumn", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = statuscolumn_group,
  callback = function()
    vim.api.nvim__redraw({ statuscolumn = true })
  end,
})

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
require("keymaps").setup()
require("autocmds").setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
