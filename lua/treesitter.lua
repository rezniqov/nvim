local ts = require("nvim-treesitter")

local parsers = {
   "javascript",
   "typescript",
   "tsx",
   "html",
   "cmake",
   "css",
   "graphql",
   "scss",
   "json",
   "yaml",
   "nginx",
   "toml",
   "sql",
   "markdown",
   "markdown_inline",
   "astro",
   "prisma",
   "lua",
   "vimdoc",
   "bash",
   "dockerfile",
   "gitignore",
   "gitcommit",
   "regex",
   "query",
}

vim.api.nvim_create_user_command("TSInstallConfigured", function()
   ts.install(parsers)
end, {
   desc = "Install configured Treesitter parsers",
})

vim.api.nvim_create_autocmd("PackChanged", {
   desc = "Install configured Treesitter parsers after nvim-treesitter changes",
   callback = function(ev)
      if ev.data.spec.name == "nvim-treesitter" then
         ts.install(parsers)
      end
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
   callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft

      local ok = pcall(vim.treesitter.start, args.buf, lang)
      if ok then
         -- сворачивание кода по treesitter
         vim.wo.foldmethod = "expr"
         vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
         vim.wo.foldenable = false -- не сворачивать при открытии файла

         -- treesitter-отступы
         vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
   end,
})
