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
| Normal | `<leader>e` | Toggle floating `nvim-tree` (`init.lua`) |
| Normal | `<leader>ff` / `<leader>fF` | Telescope file finder / live grep (`init.lua`) |
| Normal | `<leader>fb` | Telescope buffer list (`init.lua`) |
| Normal | `<leader>ft` | Workspace symbol search (guarded `telescope.lsp_dynamic_workspace_symbols`, `init.lua`) |
| Normal | `<leader>[` / `<leader>]` | Previous/next buffer (`init.lua`) |
| Normal | `<leader>d` | Close buffer (with modified check, `init.lua`) |
| Normal | `<leader>u` | Open Telescope Undo history (`lua/plugins/undo.lua`) |
| Normal | `<leader>a` | Toggle Aerial outline (`lua/plugins/outline.lua`) |
| Normal | `<leader>{` / `<leader>}` | Jump to previous/next symbol in Aerial (`lua/plugins/outline.lua`) |
| Normal | `<leader>/` | Toggle comment for current line (Comment.nvim) |
| Visual | `<leader>/` | Toggle comment for selection (Comment.nvim) |
| Normal | `gd`, `K`, `<leader>ca` | LSP definition, hover docs, code actions (`lua/plugins/lsp.lua`) |
| Normal | `<leader>r` | Rename symbol via `renamer.nvim` (`lua/plugins/rename.lua`) |
| Normal | `<leader>?` | Buffer-local which-key popup (`lua/plugins/keymap.lua`) |
| Normal | `<leader>Dv`, `<leader>Dc`, `<leader>Dh` | Diffview open/close/file history (`lua/plugins/gitdiff.lua`) |
| Terminal | `<C-\>` | Toggle floating terminal (`lua/plugins/toggleterm.lua`) |
| Terminal | `<Esc>` / `<C-h/j/k/l>` | Leave terminal / move between splits from terminal (`lua/plugins/toggleterm.lua`) |
| Visual | `J` / `K` | Move highlighted block down/up (`init.lua`) |
| Visual | `<` / `>` | Shift indent while keeping selection (`init.lua`) |

Other QoL tweaks:

- Pressing `<Esc>` clears search highlights and closes floating popups (`init.lua`).
- Telescope workspace search refuses to run when no LSP client is attached, preventing noisy errors (`init.lua`).
- Terminal buffers automatically inherit navigation mappings for seamless pane movement (`toggleterm.lua`).

Feel free to adapt the mappings to your own leader or workflow—the config is intentionally small and easy to adjust.  Enjoy!
