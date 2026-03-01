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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 診断表示の設定
      vim.diagnostic.config({
        virtual_text = true,  -- 行末にエラーメッセージを表示
        signs = true,         -- サインカラムにアイコン表示
        underline = true,     -- エラー箇所に下線
        update_in_insert = false,  -- インサートモード中は更新しない
        severity_sort = true, -- 重要度順にソート
        float = {
          border = "rounded",
          source = "always",  -- ソース（LSPサーバー名）を表示
          header = "",
          prefix = "",
        },
      })

      -- カーソルを止めたときに自動で診断メッセージを表示
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })

      -- CursorHoldの待機時間を設定（ミリ秒）
      vim.opt.updatetime = 500  -- 500ms後に自動表示

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
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local opts = { buffer = bufnr, noremap = true, silent = true }

          -- キーマップの設定（標準的なスタイル）
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "定義へジャンプ" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "宣言へジャンプ" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "実装へジャンプ" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "ホバー情報表示" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "シグネチャヘルプ" }))
          vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: シンボルをリネーム" }))
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: コードアクション" }))
          
          -- 診断メッセージ関連
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "前のエラーへ" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "次のエラーへ" }))
          -- 診断メッセージは自動表示（カーソルを0.5秒止める）のみで手動キーマップなし
          
          -- Telescopeがインストールされている場合は、参照表示にTelescopeを使用
          local has_telescope = pcall(require, "telescope.builtin")
          if has_telescope then
            vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "参照を表示" }))
          else
            vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "参照を表示" }))
          end
        end,
      })

      -- TypeScript Language Server (ts_ls) の設定（Neovim 0.11の新しいAPI）
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        capabilities = capabilities,
      }

      -- TypeScriptファイルを開いたときに自動起動
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        callback = function()
          vim.lsp.enable("ts_ls")
        end,
      })

      -- 他のLSPサーバーも同様に設定可能
      -- 例: Lua Language Server (既にインストールされている場合)
      -- vim.lsp.config.lua_ls = {
      --   cmd = { "lua-language-server" },
      --   filetypes = { "lua" },
      --   root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
      --   capabilities = capabilities,
      -- }
    end
  },
}
