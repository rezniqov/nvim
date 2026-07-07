# Neovim Config — Agent Guide

## Toolchain

- **No package manager** — uses Neovim built-in `vim.pack` (list in `lua/plugins.lua`, lockfile `nvim-pack-lock.json`)
- **No `nvim-lspconfig`** — native `vim.lsp.enable` with server configs in `lsp/`
- **Formatter**: `stylua` (Lua), `prettier` (JS/TS/JSON/CSS/HTML/MD/Astro/YAML). Format-on-save with `lsp_format = "fallback"`
- **StyLua**: 3-space indent, 100 col width, double quotes (`stylua.toml`)
- **Mason**: auto-installs `lua-language-server`, `vtsls`, `css-lsp`, `stylua`, `prettier` on startup

## Key gotchas

- **Treesitter parsers NOT auto-installed** — run `:TSInstallConfigured` manually or they install on `PackChanged` when nvim-treesitter is added/updated
- **`copilot.lua` in lockfile but not loaded** — not required in `init.lua` or `plugins.lua`, so not active
- **`blink.cmp`** must run `.build():pwait(60000)` before `.setup({})`
- **`noice.nvim`** has `messages = false` and `notify = false` — conflicts with `snacks.notifier`
- **Semantic tokens explicitly disabled** in LSP (`client.server_capabilities.semanticTokensProvider = nil`)
- **`nvim-tree`** overrides `h`/`l` navigation (close parent / open file); `on_attach` wires `Snacks.rename.on_rename_file` on node rename
- **LSP keymaps are buffer-local** — attached via `LspAttach` autocmd in `lua/lsp.lua`, not global

## Entrypoint

`init.lua` loads modules in order: `config` → `plugins` → `keymaps` → `autocmd` → `treesitter` → `lsp`, then sets colorscheme `gruvbox-material`.

## Architecture

| Path | Purpose |
|---|---|
| `lua/config.lua` | Editor options (`mapleader`, `relativenumber`, `clipboard`, etc.) |
| `lua/plugins.lua` | Plugin install + setup (biggest file, ~300 lines) |
| `lua/keymaps.lua` | Global keymaps (leader-based fzf, nvim-tree, git, notifications) |
| `lua/autocmd.lua` | Yank highlight |
| `lua/treesitter.lua` | Parser list + `:TSInstallConfigured` command + FT-triggered start |
| `lua/lsp.lua` | `vim.lsp.enable` + `LspAttach` keymaps (gd, gr, `<leader>ss`, `<leader>fo`, `<leader>uh`) |
| `lsp/*.lua` | Per-server config files (return a table — no `require` needed, `vim.lsp.enable` auto-discovers) |

## Config style

- All `vim.keymap.set` calls include `{ desc = "..." }` — `which-key` reads these automatically
- Comments are in Russian
