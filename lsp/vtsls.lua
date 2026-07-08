local astro_ts_plugin = vim.fs.joinpath(
   vim.fn.stdpath("data"),
   "mason",
   "packages",
   "astro-language-server",
   "node_modules",
   "@astrojs",
   "ts-plugin"
)

return {
   cmd = { "vtsls", "--stdio" },
   filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
   },
   root_markers = {
      {
         "package-lock.json",
         "yarn.lock",
         "pnpm-lock.yaml",
         "bun.lockb",
         "bun.lock",
      },
      "tsconfig.json",
      "package.json",
      "jsconfig.json",
      ".git",
   },
   settings = {
      typescript = {
         inlayHints = {
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = {
               enabled = true,
            },
            functionLikeReturnTypes = {
               enabled = true,
            },
            enumMemberValues = { enabled = true },
         },
         updateImportsOnFileMove = {
            enabled = "always",
         },
         suggest = {
            completeFunctionCalls = true,
         },
      },
      javascript = {
         inlayHints = {
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = {
               enabled = true,
            },
            functionLikeReturnTypes = {
               enabled = true,
            },
            enumMemberValues = { enabled = true },
         },
         updateImportsOnFileMove = {
            enabled = "always",
         },
         suggest = {
            completeFunctionCalls = true,
         },
      },
      vtsls = {
         autoUseWorkspaceTsdk = true,
         enableMoveToFileCodeAction = true,
         tsserver = {
            globalPlugins = {
               {
                  name = "@astrojs/ts-plugin",
                  location = astro_ts_plugin,
                  languages = { "astro" },
                  enableForWorkspaceTypeScriptVersions = true,
               },
            },
         },
         experimental = {
            completion = {
               enableServerSideFuzzyMatch = true,
            },
         },
      },
   },
}
