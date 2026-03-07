return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      local mason_ok, mason = pcall(require, 'mason')
      if mason_ok then
        mason.setup()
      end

      local mlsp_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
      local available_servers = {}
      if mlsp_ok then
        local ok_get, servers = pcall(mason_lspconfig.get_available_servers)
        if ok_get and type(servers) == 'table' then
          for _, server in ipairs(servers) do
            available_servers[server] = true
          end
        end
      end

      local function is_available(server)
        if not mlsp_ok or next(available_servers) == nil then
          return true
        end
        return available_servers[server] == true
      end

      local ts_server = is_available('ts_ls') and 'ts_ls' or 'tsserver'

      if mlsp_ok then
        mason_lspconfig.setup({
          -- We enable servers manually below, so disable Mason auto-enable to avoid surprises.
          automatic_enable = false,
          ensure_installed = {
            'pyright',
            'rust_analyzer',
            'clangd',
            'lua_ls',
            'vimls',
            'dockerls',
            'docker_compose_language_service',
            ts_server,
          }
        })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local blink_ok, blink = pcall(require, 'blink.cmp')
      if blink_ok and blink.get_lsp_capabilities then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      local function enable(server, opts)
        opts = opts or {}
        opts.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          capabilities,
          opts.capabilities or {}
        )
        local ok_config, config_err = pcall(vim.lsp.config, server, opts)
        if not ok_config then
          vim.notify(
            string.format("LSP config failed for '%s': %s", server, config_err),
            vim.log.levels.WARN
          )
          return
        end

        local ok_enable, enable_err = pcall(vim.lsp.enable, server)
        if not ok_enable then
          vim.notify(
            string.format("LSP enable failed for '%s': %s", server, enable_err),
            vim.log.levels.WARN
          )
        end
      end

      enable('pyright', {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
            }
          }
        }
      })

      for _, server in ipairs({
        'rust_analyzer',
        'clangd',
        'lua_ls',
        'vimls',
        'dockerls',
        'docker_compose_language_service',
        ts_server,
      }) do
        enable(server)
      end

      local function collect_workspace_edit_uris(workspace_edit)
        local uris = {}
        if not workspace_edit then
          return uris
        end

        if workspace_edit.changes then
          for uri, _ in pairs(workspace_edit.changes) do
            uris[uri] = true
          end
        end

        if workspace_edit.documentChanges then
          for _, change in ipairs(workspace_edit.documentChanges) do
            if change and change.textDocument and change.textDocument.uri then
              uris[change.textDocument.uri] = true
            end
          end
        end

        return uris
      end

      local function save_renamed_files(uris)
        local saved = {}
        local failed = {}

        for uri, _ in pairs(uris) do
          local fname = vim.uri_to_fname(uri)
          local bufnr = vim.uri_to_bufnr(uri)

          if not vim.api.nvim_buf_is_loaded(bufnr) then
            pcall(vim.fn.bufload, bufnr)
          end

          local can_write = vim.api.nvim_buf_is_loaded(bufnr)
            and vim.bo[bufnr].buftype == ''
            and vim.bo[bufnr].modifiable
            and vim.bo[bufnr].modified
            and fname ~= ''

          if can_write then
            local ok_write, write_err = pcall(vim.api.nvim_buf_call, bufnr, function()
              vim.cmd('silent write')
            end)
            if ok_write then
              table.insert(saved, fname)
            else
              table.insert(failed, string.format('%s (%s)', fname, write_err))
            end
          end
        end

        return saved, failed
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>r', function()
            local clients = vim.lsp.get_clients({ bufnr = event.buf })
            local can_rename = false

            for _, client in ipairs(clients) do
              if client:supports_method('textDocument/rename') then
                can_rename = true
                break
              end
            end

            if not can_rename then
              vim.notify('No LSP client with rename support in this buffer', vim.log.levels.WARN)
              return
            end

            local cword = vim.fn.expand('<cword>')
            vim.ui.input({ prompt = 'New Name: ', default = cword }, function(input)
              local new_name = input and vim.trim(input) or ''
              if new_name == '' or new_name == cword then
                return
              end

              local methods = vim.lsp.protocol.Methods
              local selected_result
              local selected_client
              local last_error

              for _, client in ipairs(clients) do
                if client:supports_method(methods.textDocument_rename) then
                  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
                  params.newName = new_name

                  local response, request_err = client:request_sync(
                    methods.textDocument_rename,
                    params,
                    5000,
                    event.buf
                  )

                  if request_err then
                    last_error = string.format('%s: %s', client.name, request_err)
                  elseif response and response.err then
                    last_error = string.format('%s: %s', client.name, response.err.message or 'rename error')
                  elseif response and response.result then
                    selected_result = response.result
                    selected_client = client
                    break
                  end
                end
              end

              if not selected_result or not selected_client then
                vim.notify(last_error or 'Nothing to rename', vim.log.levels.INFO)
                return
              end

              local ok_apply, apply_err = pcall(
                vim.lsp.util.apply_workspace_edit,
                selected_result,
                selected_client.offset_encoding
              )
              if not ok_apply then
                vim.notify(string.format('Failed to apply rename edit: %s', apply_err), vim.log.levels.ERROR)
                return
              end

              local affected_uris = collect_workspace_edit_uris(selected_result)
              local saved, failed = save_renamed_files(affected_uris)

              if #saved > 0 then
                local preview = vim.iter(saved):map(function(path)
                  return vim.fn.fnamemodify(path, ':.')
                end):totable()
                local head = table.concat(vim.list_slice(preview, 1, math.min(#preview, 5)), ', ')
                local tail = (#preview > 5) and string.format(' (+%d more)', #preview - 5) or ''
                vim.notify(
                  string.format('Rename applied and saved %d file(s): %s%s', #saved, head, tail),
                  vim.log.levels.INFO
                )
              else
                vim.notify('Rename applied, but no modified files were saved', vim.log.levels.INFO)
              end

              if #failed > 0 then
                vim.notify(
                  string.format('Rename save failed for %d file(s). Check :messages', #failed),
                  vim.log.levels.WARN
                )
                for _, msg in ipairs(failed) do
                  vim.notify(msg, vim.log.levels.WARN)
                end
              end
            end)
          end, opts)
        end,
      })
    end
  }
}
