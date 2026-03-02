-- conform.nvim: フォーマッター統合
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      -- ファイルタイプごとのフォーマッター設定
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },

      -- フォーマッターの設定
      formatters = {
        prettier = {
          -- プロジェクトのnode_modules内のprettierを優先使用
          -- なければグローバルにフォールバック
          command = "prettier",
          args = { "--stdin-filepath", "$FILENAME" },
        },
      },

      -- フォーマットオプション
      format_on_save = nil, -- 保存時の自動フォーマットは無効（手動のみ）
    })

    -- 手動フォーマット用のキーマップ
    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "LSP: フォーマット (Prettier)" })
  end,
}
