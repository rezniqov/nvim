return {
   cmd = { "vscode-eslint-language-server", "--stdio" },
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
      ".git",
   },
   workspace_required = true,
   settings = {
      validate = "on",
      packageManager = "yarn",
      useESLintClass = true,
      experimental = {
         useFlatConfig = true,
      },
      options = {
         overrideConfig = {
            rules = {
               ["no-undef"] = "error",
            },
         },
      },
      codeActionOnSave = {
         enable = false,
         mode = "all",
      },
      format = false,
      quiet = false,
      onIgnoredFiles = "off",
      rulesCustomizations = {},
      run = "onType",
      problems = {
         shortenToSingleLine = true,
      },
      nodePath = "",
      workingDirectory = {
         mode = "auto",
      },
      codeAction = {
         disableRuleComment = {
            enable = true,
            location = "separateLine",
         },
         showDocumentation = {
            enable = true,
         },
      },
   },
   before_init = function(_, config)
      config.settings.workspaceFolder = {
         uri = vim.uri_from_fname(config.root_dir),
         name = vim.fn.fnamemodify(config.root_dir, ":t"),
      }
   end,
   handlers = {
      ["eslint/confirmESLintExecution"] = function()
         return 4
      end,
   },
}
