-- lua/config/keymaps.lua
local map = vim.keymap.set

local fzf = require("fzf-lua")

local function git_root()
   local bufname = vim.api.nvim_buf_get_name(0)
   local path = bufname ~= "" and vim.bo.buftype == "" and bufname or vim.fn.getcwd(0)
   local root = vim.fs.root(path, ".git")

   return root or vim.fn.getcwd(0)
end

-- ── Поиск (fzf-lua) ──────────────────────────────────────────────
map("n", "<leader><leader>", fzf.files, { desc = "Найти файл", silent = true })
map("n", "<leader>/", fzf.live_grep, {
   desc = "Поиск по тексту (grep)",
   silent = true,
})
map("n", "<leader>fb", fzf.buffers, {
   desc = "Открытые буферы",
   silent = true,
})
map("n", "<leader>fr", fzf.oldfiles, {
   desc = "Недавние файлы",
   silent = true,
})
map("n", "<leader>fh", fzf.help_tags, { desc = "Справка Neovim", silent = true })
map("n", "<leader>fd", fzf.diagnostics_document, {
   desc = "Диагностика в буфере",
   silent = true,
})

-- ── Файловый менеджер (nvim-tree) ───────────────────────────────
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", {
   desc = "Показать/скрыть дерево файлов",
   silent = true,
})

map("n", "<leader>xq", fzf.quickfix, { desc = "Quickfix list", silent = true })
map("n", "<leader>b", fzf.buffers, { desc = "buffers", silent = true })

-- common
map("n", "<Esc>", "<cmd>nohlsearch<cr>", {
   desc = "Убрать подсветку поиска",
   silent = true,
})
map("n", "<C-s>", "<cmd>w<cr>", {
   desc = "Сохранить файл",
   silent = true,
})
map("n", "<leader>q", "<cmd>q<cr>", {
   desc = "Закрыть окно",
   silent = true,
})

-- git
map("n", "<leader>gg", function()
   Snacks.lazygit()
end, { desc = "LazyGit", silent = true })

map("n", "<leader>ub", function()
   require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle line blame", silent = true })

-- terminal
local function terminal_opts()
   return {
      cwd = git_root(),
      win = {
         position = "bottom",
         height = 0.35,
      },
   }
end

local function toggle_git_root_terminal()
   Snacks.terminal.toggle(nil, terminal_opts())
end

local function hide_current_terminal()
   local win = vim.api.nvim_get_current_win()
   local buf = vim.api.nvim_get_current_buf()

   for _, terminal in ipairs(Snacks.terminal.list()) do
      if terminal.win == win or terminal.buf == buf then
         terminal:hide()
         return
      end
   end

   toggle_git_root_terminal()
end

map("n", "<C-/>", toggle_git_root_terminal, { desc = "Терминал", silent = true })
map("n", "<C-_>", toggle_git_root_terminal, { desc = "Терминал", silent = true })
map("t", "<C-/>", hide_current_terminal, { desc = "Скрыть терминал", silent = true })
map("t", "<C-_>", hide_current_terminal, { desc = "Скрыть терминал", silent = true })

map("n", "<leader>td", function()
   Snacks.terminal("yarn dev", {
      cwd = git_root(),
   })
end, { desc = "yarn dev", silent = true })

--notifications
map("n", "<leader>n", function()
   Snacks.notifier.show_history()
end, { desc = "Notifocation history", silent = true })
