-- LSP設定
return {
  -- Mason: LSPサーバー管理ツール
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },

  -- Mason-lspconfig: MasonとLspconfigの連携
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- 自動インストールするLSPサーバー
        ensure_installed = {
          "ts_ls",  -- TypeScript Language Server
        },
        automatic_installation = true,
      })
    end
  },

  -- Lspconfig: LSPの基本設定
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 診断表示の設定
      vim.diagnostic.config({
        virtual_text = true,  -- 行末にエラーメッセージを表示
        signs = true,         -- サインカラムにアイコン表示
        underline = true,     -- エラー箇所に下線
        update_in_insert = false,  -- インサートモード中は更新しない
        severity_sort = true, -- 重要度順にソート
      })

      -- サインカラムのアイコン設定
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- LSPが起動したときのキーマップ設定
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- キーマップの設定（標準的なスタイル）
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "定義へジャンプ" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "宣言へジャンプ" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "実装へジャンプ" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "ホバー情報表示" }))
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "シグネチャヘルプ" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "シンボルをリネーム" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "コードアクション" }))
        
        -- 診断メッセージ関連
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "前のエラーへ" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "次のエラーへ" }))
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "診断メッセージ表示" }))
        
        -- Telescopeがインストールされている場合は、参照表示にTelescopeを使用
        local has_telescope = pcall(require, "telescope.builtin")
        if has_telescope then
          vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "参照を表示" }))
        else
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "参照を表示" }))
        end
      end

      -- TypeScript Language Server (ts_ls) の設定
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
      })

      -- 他のLSPサーバーも同様に設定可能
      -- 例: Lua Language Server (既にインストールされている場合)
      -- lspconfig.lua_ls.setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })
    end
  },
}
