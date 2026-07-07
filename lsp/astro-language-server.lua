local tsdk = vim.fs.joinpath(
   vim.fn.stdpath("data"),
   "mason",
   "packages",
   "astro-language-server",
   "node_modules",
   "typescript",
   "lib"
)

return {
   cmd = { "astro-ls", "--stdio" },
   filetypes = { "astro" },
   root_markers = {
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git",
   },
   init_options = {
      typescript = {
         tsdk = tsdk,
      },
   },
}
