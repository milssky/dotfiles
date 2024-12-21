return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- Размер терминала
                size = 20,
                -- Открывать в горизонтальном split
                direction = 'float',
                -- Включить поддержку чисел для создания нескольких терминалов
                open_mapping = [[<c-\>]],
                -- Включить поддержку плавающего режима
                float_opts = {
                    border = 'curved'
                },
                -- Включить закрытие терминала при выходе из Neovim
                close_on_exit = true,
            })
            
            -- Определение функции для установки keymaps в терминальном режиме
            function _G.set_terminal_keymaps()
                local opts = {buffer = 0}
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            end

            -- Автокоманда для установки keymaps при входе в терминальный режим
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end
    }
}
