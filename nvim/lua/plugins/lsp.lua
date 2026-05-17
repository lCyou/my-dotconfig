-- LSP設定
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
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

      -- Organize Imports 
      local function organize_imports()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
        vim.lsp.buf.execute_command(params)
      end

      -- LSPが起動したときのキーマップ設定
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local opts = { buffer = bufnr, noremap = true, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "定義へジャンプ" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "宣言へジャンプ" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "実装へジャンプ" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "ホバー情報表示" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "シグネチャヘルプ" }))
          vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: シンボルをリネーム" }))
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: コードアクション" }))
          
          -- TypeScript専用: Organize Imports
          if client and client.name == "ts_ls" then
            vim.keymap.set("n", "<leader>lo", organize_imports, vim.tbl_extend("force", opts, { desc = "LSP: Organize Imports" }))
          end
          
          -- 診断メッセージ関連
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "前のエラーへ" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "次のエラーへ" }))
          
          local has_telescope = pcall(require, "telescope.builtin")
          if has_telescope then
            vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "参照を表示" }))
          else
            vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "参照を表示" }))
          end
        end,
      })

      -- TypeScript/JavaScriptファイル保存時に自動でOrganize Imports実行
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function()
          -- ts_lsが起動している場合のみ実行
          local clients = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })
          if #clients > 0 then
            organize_imports()
            vim.wait(100)
          end
        end,
      })

      -- TypeScript Language Server設定
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

      -- Rustファイルを開いたときに自動起動
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust" },
        callback = function()
          vim.lsp.enable("rust_analyzer")
        end,
      })

      -- rust-analyzer の設定
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", "rust-project.json" },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,  -- すべてのCargoフィーチャーを有効化
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,  -- プロシージャマクロを有効化
            },
            checkOnSave = {
              command = "clippy",  -- 保存時にclippyでチェック
            },
          },
        },
      }
    end
  },
}
