local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
    group = group,
    callback = function(args)
      local buf = args.buf
      local bo = vim.bo[buf]

      if bo.readonly or not bo.modifiable or bo.buftype ~= "" or not bo.modified then
        return
      end

      local name = vim.api.nvim_buf_get_name(buf)
      if name == "" then
        return
      end

      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent write")
      end)
    end,
  })
end

return M
