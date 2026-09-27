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
        lua = { "stylua" },
        rust = { "rustfmt" },
        nix = { "nixfmt" },
        java = { "google-java-format" },
      },

      -- フォーマッターの設定
      formatters = {
        prettier = {
          command = "prettier",
          args = { "--stdin-filepath", "$FILENAME" },
        },
        ["google-java-format"] = {
          command = "google-java-format",
          args = { "-" },
        },
      },

      -- フォーマットオプション
      format_on_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        if filetype == "rust" then
          return { timeout_ms = 500, lsp_fallback = true }
        elseif filetype == "java" then
          -- JVM 起動のため長めのタイムアウト
          return { timeout_ms = 2000, lsp_fallback = false }
        end
        return nil
      end,
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
