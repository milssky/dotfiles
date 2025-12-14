return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'linrongbin16/lsp-progress.nvim'
  },
  config = function()
    local lualine = require('lualine')

    local function lsp_status()
      return (#vim.lsp.get_clients() > 0) and '' or ''
    end

    local function diagnostics_count()
      local errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
      local warnings = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
      if errors == 0 and warnings == 0 then
        return ''
      end
      return string.format("E:%d W:%d", errors, warnings)
    end

    local mode_map = {
      ['n'] = 'N',
      ['i'] = 'I',
      ['v'] = 'V',
      ['V'] = 'V',
      ['c'] = 'C',
      ['R'] = 'R',
      ['t'] = 'T'
    }

    lualine.setup {
      options = {
        theme = 'gruvbox',
        component_separators = { left = '│', right = '│' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          diagnostics_count,
        },
        lualine_y = {
          'branch',
          {
            'filename',
            path = 1,  -- relative path
            symbols = {
              modified = '●',
              readonly = 'R',
              unnamed = '[No Name]',
            }
          },
          lsp_status,
        },
        lualine_z = {
          'location',
          {
            function()
              return mode_map[vim.fn.mode()] or vim.fn.mode()
            end,
            padding = { left = 1, right = 1 },
          }
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
