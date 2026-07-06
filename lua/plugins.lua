vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local function gh(repo)
   return "https://github.com/" .. repo
end
-- plugin install
vim.pack.add({
   -- ts
   {
      src = gh("nvim-treesitter/nvim-treesitter"),
      version = "main",
   },

   -- file tree + icons
   { src = gh("nvim-tree/nvim-tree.lua") },
   { src = gh("nvim-tree/nvim-web-devicons") },
   -- theme
   { src = gh("folke/tokyonight.nvim") },
   { src = gh("sainnhe/gruvbox-material") },
   -- mason
   {
      src = "https://github.com/mason-org/mason.nvim",
   },
   {
      src = gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
   },
   -- lualine
   { src = gh("nvim-lualine/lualine.nvim") },
   -- search
   { src = gh("ibhagwan/fzf-lua") },
   -- formatter
   { src = gh("stevearc/conform.nvim") },
   -- git signs
   { src = gh("lewis6991/gitsigns.nvim") },
   -- keymap hints
   { src = gh("folke/which-key.nvim") },
   -- blink cmp
   { src = gh("saghen/blink.lib") },
   { src = gh("saghen/blink.cmp") },
   -- autopairs
   { src = gh("windwp/nvim-autopairs") },
   -- snacks
   { src = gh("folke/snacks.nvim") },
   { src = gh("MunifTanjim/nui.nvim") },
   { src = gh("folke/noice.nvim") },
})

require("snacks").setup({
   lazygit = { enabled = true },
   indent = { enabled = true },
   image = { enabled = true },
   rename = { enabled = true },
   notifier = { enabled = true },
})

require("noice").setup({
   lsp = {
      override = {
         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
         ["vim.lsp.util.stylize_markdown"] = true,
      },
   },

   -- отключаем те части noice, что конфликтуют с snacks.notifier
   messages = { enabled = false },
   notify = { enabled = false },

   cmdline = { enabled = true },
   popupmenu = { enabled = true },

   presets = {
      bottom_search = true,
      command_palette = true, -- центрированная cmdline + popupmenu
      long_message_to_split = true,
      lsp_doc_border = true,
   },
})

require("tokyonight").setup({})
require("mason").setup({})
require("mason-tool-installer").setup({
   ensure_installed = {
      "lua-language-server",
      "vtsls",
      "css-lsp",
      "stylua",
      "prettier",
   },
   run_on_start = true,
   auto_update = false,
})
require("lualine").setup()
require("nvim-web-devicons").setup()
require("which-key").setup({
   preset = "helix",
   spec = {
      {
         mode = { "n", "x" },
         { "<leader>f", group = "find" },
         { "<leader>x", group = "diagnostics/quickfix" },
         { "<leader>g", group = "git" },
         { "<leader>u", group = "ui/toggles" },
         { "<leader>s", group = "search/symbols" },
         { "g", group = "goto" },
      },
   },
})
require("gitsigns").setup({
   current_line_blame = true,
})

local function nvim_tree_on_attach(bufnr)
   local api = require("nvim-tree.api")

   -- Стандартные бинды
   api.config.mappings.default_on_attach(bufnr)

   local function opts(desc)
      return {
         desc = "nvim-tree: " .. desc,
         buffer = bufnr,
         noremap = true,
         silent = true,
         nowait = true,
      }
   end

   -- h — свернуть папку / перейти к родителю
   vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

   -- l — открыть файл / развернуть папку
   vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
end

require("nvim-tree").setup({
   view = {
      width = 32,
   },
   renderer = {
      group_empty = true,
      highlight_git = true,
   },
   filters = {
      dotfiles = false,
   },
   git = {
      enable = true,
   },
   diagnostics = {
      enable = true,
   },
   on_attach = nvim_tree_on_attach,
   update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = {},
   },
})

local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
   pattern = "NvimTreeSetup",
   callback = function()
      local events = require("nvim-tree.api").events
      events.subscribe(events.Event.NodeRenamed, function(data)
         if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
            prev.new_name = data.new_name
            prev.old_name = data.old_name
            Snacks.rename.on_rename_file(data.old_name, data.new_name)
         end
      end)
   end,
})

require("conform").setup({
   formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },
      astro = { "prettier" },
      yaml = { "prettier" },
   },

   format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback", -- если для filetype нет форматтера выше — попробовать LSP
   },
})

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
   winopts = { backdrop = 85 },
   keymap = {
      builtin = {
         ["<C-f>"] = "preview-page-down",
         ["<C-b>"] = "preview-page-up",
         ["<C-p>"] = "toggle-preview",
      },
      fzf = {
         ["ctrl-a"] = "toggle-all",
         ["ctrl-t"] = "first",
         ["ctrl-g"] = "last",
         ["ctrl-d"] = "half-page-down",
         ["ctrl-u"] = "half-page-up",
      },
   },
   actions = {
      files = {
         ["ctrl-q"] = actions.file_sel_to_qf,
         ["enter"] = actions.file_edit_or_qf,
      },
   },

   files = {
      hidden = true,
      ignore_git = false,
      fd_opts = "--color=never --hidden --no-ignore --type f --type l --follow --exclude .git --exclude node_modules --exclude dist --exclude .next",
   },

   grep = {
      hidden = true,
      ignore_git = false,
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore -g '!.git' -g '!**/node_modules/**' -g '!**/dist/**' -g '!**/.next/**'",
   },
})

require("blink.cmp").build():pwait(60000)
require("blink.cmp").setup({
   fuzzy = { implementation = "prefer_rust" },
   signature = { enabled = true },
   keymap = {
      preset = "default",
      ["<C-space>"] = { "show" },
      ["<CR>"] = {
         "select_and_accept",
         "fallback",
      },
      ["<C-p>"] = {},
      ["<Tab>"] = {},
      ["<S-Tab>"] = {},
      ["<C-y>"] = {
         "show",
         "show_documentation",
         "hide_documentation",
      },
      ["<C-n>"] = {},
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = {
         "scroll_documentation_down",
         "fallback",
      },
      ["<C-f>"] = {
         "scroll_documentation_up",
         "fallback",
      },
      ["<C-l>"] = {
         "snippet_forward",
         "fallback",
      },
      ["<C-h>"] = {
         "snippet_backward",
         "fallback",
      },
      -- ["<C-e>"] = { "hide" },
   },

   appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
   },

   completion = {
      documentation = {
         auto_show = true,
         auto_show_delay_ms = 200,
      },
   },

   cmdline = {
      keymap = {
         preset = "inherit",
         ["<CR>"] = {
            "accept_and_enter",
            "fallback",
         },
      },
   },

   sources = { default = { "lsp" } },
})

require("nvim-autopairs").setup({})
