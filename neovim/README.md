# Neovim Config

Custom Neovim setup powered by [lazy.nvim](https://github.com/folke/lazy.nvim).  The config focuses on a light UI, floating file tree, solid LSP experience, and a few focused plugins for day-to-day development (mainly Python, Rust, and C/C++).

## Plugin Highlights

- **Theme & UI**: `gruvbox.nvim`, `lualine.nvim` with a single minimal statusline, `vim-illuminate` for repeated word highlights.
- **Navigation**: Floating `nvim-tree` file explorer, `telescope.nvim` for fuzzy finding, `aerial.nvim` (via `outline.lua`) for symbol outline, `diffview.nvim` for Git history/diffs.
- **Editing**: `nvim-cmp` with LuaSnip snippets, `Comment.nvim` (+ Treesitter context) for contextual comments, `toggleterm.nvim` for floating terminals, `telescope-undo` integration.
- **LSP & Diagnostics**: Built-in LSP configured through `vim.lsp.config` with pyright, rust-analyzer, clangd, lua-language-server, vimls, docker servers; `lsp-progress` + lualine for status feedback; quick LSP keymaps out of the box.
- **Python tooling**: `venv-selector.nvim` to pick and auto-activate virtualenvs, convenient Poetry path integration, direct bindings for cached env reuse.
- **Quality of life**: `which-key.nvim`, `nvim-tree` icons, `renamer.nvim`, `trouble.nvim`, Treesitter highlighting, and various visual tweaks (buffer close prompts, floating window escape helper).

Each plugin’s config lives in `lua/plugins/*.lua`, so it’s easy to tweak individual features.

## Keymaps

| Mode | Mapping | Action |
| ---- | ------- | ------ |
| Normal | `<leader>e` | Toggle floating `nvim-tree` (`lua/keymaps.lua`) |
| Normal | `<leader>ff` / `<leader>fF` | Telescope file finder / live grep (`lua/keymaps.lua`) |
| Normal | `<leader>d` | Telescope buffer list (`lua/keymaps.lua`) |
| Normal | `<leader>w` | Close buffer with modified check (`lua/keymaps.lua`) |
| Normal | `<leader>t` | Workspace symbol search (guarded `telescope.lsp_dynamic_workspace_symbols`, `lua/keymaps.lua`) |
| Normal | `<leader>W` | Cycle through windows (`lua/keymaps.lua`) |
| Normal | `<leader>P` | Jump to previous window (`lua/keymaps.lua`) |
| Normal | `<leader>[` / `<leader>]` | Previous/next buffer (`lua/keymaps.lua`) |
| Normal | `<leader>vs` / `<leader>vc` | Select / reactivate cached virtualenv (`lua/plugins/python.lua`) |
| Normal | `<leader>u` | Open Telescope Undo history (`lua/plugins/undo.lua`) |
| Normal | `<leader>a` | Toggle Aerial outline (`lua/plugins/outline.lua`) |
| Normal | `<leader>{` / `<leader>}` | Jump to previous/next symbol in Aerial (`lua/plugins/outline.lua`) |
| Normal | `<leader>/` / `<leader>?` | Comment line / block (Comment.nvim) |
| Visual | `<leader>/` / `<leader>?` | Comment selection / block (Comment.nvim) |
| Normal | `gd`, `K`, `<leader>ca` | LSP definition, hover docs, code actions (`lua/plugins/lsp.lua`) |
| Normal | `<leader>r` | Rename symbol via `renamer.nvim` (`lua/plugins/rename.lua`) |
| Normal | `<leader>?` | Buffer-local which-key popup (`lua/plugins/keymap.lua`) |
| Normal | `<leader>Dv`, `<leader>Dc`, `<leader>Dh` | Diffview open/close/file history (`lua/plugins/gitdiff.lua`) |
| Terminal | `<C-\>` | Toggle floating terminal (`lua/plugins/toggleterm.lua`) |
| Terminal | `<Esc>` / `<C-h/j/k/l>` | Leave terminal / move between splits from terminal (`lua/plugins/toggleterm.lua`) |
| Visual | `J` / `K` | Move highlighted block down/up (`lua/keymaps.lua`) |
| Visual | `<` / `>` | Shift indent while keeping selection (`lua/keymaps.lua`) |

Other QoL tweaks:

- Pressing `<Esc>` clears search highlights and closes floating popups (`lua/keymaps.lua`).
- Telescope workspace search refuses to run when no LSP client is attached, preventing noisy errors (`lua/keymaps.lua`).
- Terminal buffers automatically inherit navigation mappings for seamless pane movement (`toggleterm.lua`).

All general keymaps now live in `lua/keymaps.lua`; plugin-specific ones stay near their configs. Feel free to tweak them in one place.

Feel free to adapt the mappings to your own leader or workflow—the config is intentionally small and easy to adjust.  Enjoy!
