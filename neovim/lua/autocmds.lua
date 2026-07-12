local M = {}

function M.setup()
  local ag = vim.api.nvim_create_augroup

  local highlight_group = ag('YankHighlight', { clear = true })
  local diagnostic_group = ag('DiagnosticFloat', { clear = true })

  vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
      vim.highlight.on_yank({ timeout = 170, on_visual = true, on_visual_line = true })
    end,
    group = highlight_group,
  })

  vim.api.nvim_create_autocmd('CursorHold', {
    pattern = '*',
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = diagnostic_group,
  })
end

return M
