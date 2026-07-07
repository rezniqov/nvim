local function described(x, desc)
   return vim.tbl_extend("force", x, { desc = desc })
end

local function lsp_attach(data)
   local bufopts = {
      noremap = true,
      silent = true,
      buffer = data.buf,
   }

   local client = vim.lsp.get_client_by_id(data.data.client_id)
   if not client then
      return
   end

   if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.keymap.set("n", "<leader>uh", function()
         local filter = { bufnr = data.buf }
         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
      end, described(bufopts, "Toggle Inlay Hints"))
   end

   vim.keymap.set("n", "gd", vim.lsp.buf.definition, described(bufopts, "Go to definition"))
   vim.keymap.set("n", "gr", function()
      require("fzf-lua").lsp_references({
         ignore_current_line = true,
         includeDeclaration = false,
      })
   end, described(bufopts, "Go references"))
   vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, described(bufopts, "Rename symbol"))
   vim.keymap.set(
      "n",
      "<leader>ss",
      require("fzf-lua").lsp_document_symbols,
      described(bufopts, "Document symbols")
   )
   vim.keymap.set("n", "<Leader>fo", function()
      vim.lsp.buf.format({ bufnr = data.buf })
   end, described(bufopts, "Отформатировать буфер"))

   client.server_capabilities.semanticTokensProvider = nil
end

vim.lsp.enable({
   "vtsls",
   "lua_ls",
   "cssls",
})

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("lsp", {}),
   callback = lsp_attach,
})
