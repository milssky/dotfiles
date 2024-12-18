return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'linrongbin16/lsp-progress.nvim'
  },
  config = function()
    local lualine = require('lualine')

    -- Функция для отображения статуса LSP
    local function lsp_status()
      local active_clients = vim.lsp.get_active_clients()
      if #active_clients > 0 then
        local client_names = {}
        for _, client in ipairs(active_clients) do
          local name = client.name
          -- Специальная обработка для конкретных LSP
          if name == "pyright" then name = "Py" 
          elseif name == "ruff_lsp" then name = "Ruff" end
          table.insert(client_names, name)
        end
        return table.concat(client_names, " + ")
      end
      return "No LSP"
    end

    -- Функция для подсчета диагностических сообщений
    local function diagnostics_count()
      local errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
      local warnings = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
      return string.format("E:%d W:%d", errors, warnings)
    end

    -- Определение режимов
    local mode_map = {
      ['n'] = 'NORMAL',
      ['i'] = 'INSERT',
      ['v'] = 'VISUAL',
      ['V'] = 'V-LINE',
      ['c'] = 'COMMAND',
      ['R'] = 'REPLACE',
      ['t'] = 'TERMINAL'
    }

    lualine.setup {
      options = {
        theme = 'nord',
        component_separators = { left = '│', right = '│' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            function()
              return mode_map[vim.fn.mode()] or vim.fn.mode()
            end,
            padding = { left = 1, right = 1 },
          }
        },
        lualine_b = {
          'branch',
          'diff',
          {
            'filename',
            path = 1,  -- Относительный путь
            symbols = {
              modified = '●',
              readonly = 'R',
              unnamed = '[No Name]',
            }
          }
        },
        lualine_c = {
          lsp_status,  -- Используем нашу кастомную функцию
        },
        lualine_x = {
          diagnostics_count,
          'encoding',
          'fileformat',
        },
        lualine_y = {
          'progress'
        },
        lualine_z = {
          'location'
        }
      },
      extensions = {
        'nvim-tree',
        'quickfix',
        'toggleterm'
      }
    }
  end
}
