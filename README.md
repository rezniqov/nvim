# Neovim Config

Личная конфигурация Neovim на встроенном менеджере пакетов `vim.pack` и native LSP через `vim.lsp.enable`. `nvim-lspconfig` не используется.

## Структура

- `init.lua` - точка входа: загружает `config`, `plugins`, `keymaps`, `autocmd`, `treesitter`, `lsp`, затем включает `gruvbox-material`.
- `lua/config.lua` - базовые опции редактора.
- `lua/plugins.lua` - установка и настройка плагинов.
- `lua/keymaps.lua` - глобальные keymaps с `desc` для `which-key`.
- `lua/autocmd.lua` - общие autocmd, сейчас yank highlight.
- `lua/treesitter.lua` - список парсеров, команда `:TSInstallConfigured`, запуск Treesitter по `FileType`.
- `lua/lsp.lua` - включение LSP-серверов, диагностика и buffer-local LSP keymaps.
- `lsp/*.lua` - native LSP server configs.
- `nvim-pack-lock.json` - lockfile для `vim.pack`.
- `stylua.toml` - правила форматирования Lua.

## Основные настройки

- Leader: `<Space>`.
- Номера строк: абсолютные и относительные.
- Clipboard: `unnamedplus`.
- Окна LSP/UI: rounded border через `winborder`.
- Перенос строк: `wrap`, `linebreak`, `breakindent`.
- Statusline: global statusline через `laststatus = 3`.
- Cmdline height: `cmdheight = 0`.
- Colorscheme: `gruvbox-material`.

## Плагины

- `nvim-treesitter/nvim-treesitter` - Treesitter parsers, folds, indentation.
- `nvim-tree/nvim-tree.lua` - file tree.
- `nvim-tree/nvim-web-devicons` - icons.
- `folke/tokyonight.nvim` - установленная тема, сейчас не активна.
- `sainnhe/gruvbox-material` - активная тема.
- `mason-org/mason.nvim` - менеджер внешних LSP/tool бинарей.
- `WhoIsSethDaniel/mason-tool-installer.nvim` - автоустановка Mason tools.
- `nvim-lualine/lualine.nvim` - statusline.
- `ibhagwan/fzf-lua` - files, grep, buffers, diagnostics, LSP lists.
- `stevearc/conform.nvim` - форматирование.
- `lewis6991/gitsigns.nvim` - Git signs и current line blame.
- `folke/which-key.nvim` - подсказки keymaps, preset `helix`.
- `saghen/blink.lib` и `saghen/blink.cmp` - completion.
- `windwp/nvim-autopairs` - автопары для скобок и кавычек.
- `folke/snacks.nvim` - lazygit, terminal, indent guides, image, rename, notifier.
- `MunifTanjim/nui.nvim` - UI dependency для `noice.nvim`.
- `folke/noice.nvim` - cmdline, popupmenu и LSP UI.

## Mason Tools

Эти инструменты ставятся автоматически при старте Neovim, если отсутствуют:

- `lua-language-server`
- `vtsls`
- `css-lsp`
- `stylua`
- `prettier`
- `astro-language-server`

`auto_update = false`, поэтому версии не обновляются автоматически.

## LSP

LSP включается в `lua/lsp.lua`:

- `lua_ls` - Lua.
- `vtsls` - JavaScript, TypeScript, JSX, TSX.
- `cssls` - CSS, SCSS, Less.
- `astro-language-server` - Astro.

## Formatting

Форматирование делает `conform.nvim`.

- Lua: `stylua`.
- JavaScript, JSX, TypeScript, TSX: `prettier`.
- JSON, JSONC: `prettier`.
- CSS, HTML, Markdown, Astro, YAML: `prettier`.

Format-on-save включен:

```lua
format_on_save = {
   timeout_ms = 1000,
   lsp_format = "fallback",
}
```

## Treesitter

Парсеры не ставятся на каждом старте. Для ручной установки всего списка:

```vim
:TSInstallConfigured
```

Парсеры также ставятся автоматически после события `PackChanged`, если изменился `nvim-treesitter`.

Список настроенных парсеров: JavaScript, TypeScript, TSX, HTML, CSS, SCSS, JSON, YAML, Markdown, Astro, Prisma, Lua, Bash, Dockerfile, Git, Regex, Query и другие из `lua/treesitter.lua`.

## Keymaps

Глобальные mappings:

- `<leader><leader>` - найти файл через `fzf-lua`.
- `<leader>/` - live grep.
- `<leader>fb` - открытые буферы.
- `<leader>fr` - недавние файлы.
- `<leader>fh` - help tags.
- `<leader>fd` - диагностика текущего буфера.
- `<leader>e` - показать/скрыть `nvim-tree`.
- `<leader>xq` - quickfix list.
- `<leader>b` - buffers.
- `<Esc>` - убрать подсветку поиска.
- `<C-s>` - сохранить файл.
- `<leader>q` - закрыть окно.
- `<leader>gg` - LazyGit через Snacks.
- `<leader>ub` - toggle Git current line blame.
- `<C-/>` / `<C-_>` в normal mode - открыть/скрыть terminal в Git root.
- `<C-/>` / `<C-_>` в terminal mode - скрыть текущий terminal.
- `<leader>td` - запустить `yarn dev` в Git root.
- `<leader>n` - история уведомлений Snacks.

LSP mappings создаются buffer-local после `LspAttach`:

- `gd` - go to definition.
- `gr` - references через `fzf-lua`.
- `<leader>cr` - rename symbol.
- `<leader>ss` - document symbols.
- `<leader>fo` - format current buffer.
- `<leader>uh` - toggle inlay hints, если сервер поддерживает.

## Completion

Completion настроен через `blink.cmp`.

- Перед `setup()` вызывается `require("blink.cmp").build():pwait(60000)`.
- Источники completion: только `lsp`.
- Documentation popup показывается автоматически с задержкой `200ms`.
- `<CR>` принимает выбранный completion item или делает fallback.
- `<C-k>` / `<C-j>` - предыдущий/следующий item.
- `<C-b>` / `<C-f>` - scroll documentation.
- `<C-l>` / `<C-h>` - переход вперед/назад по snippet.
