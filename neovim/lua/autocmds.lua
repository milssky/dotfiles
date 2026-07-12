local M = {}

function M.setup()
  local ag = vim.api.nvim_create_augroup

  local highlight_group = ag('YankHighlight', { clear = true })
  local diagnostic_group = ag('DiagnosticFloat', { clear = true })
  local ui_group = ag('UserUiHighlights', { clear = true })

  local function match_gutter_to_normal()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    local bg = normal.bg or 'none'

    for _, group in ipairs({
      'CursorLineNr',
      'FoldColumn',
      'LineNr',
      'LineNrAbove',
      'LineNrBelow',
      'SignColumn',
    }) do
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      if ok then
        hl.bg = bg
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end

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

  match_gutter_to_normal()
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = match_gutter_to_normal,
    group = ui_group,
  })
end

return M
