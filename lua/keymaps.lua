-- lua/config/keymaps.lua
local map = vim.keymap.set

local fzf = require("fzf-lua")

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

--notifications
map("n", "<leader>n", function()
   Snacks.notifier.show_history()
end, { desc = "Notifocation history", silent = true })
