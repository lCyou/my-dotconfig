-- nvim-lint: リンター統合
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- ファイルタイプごとのリンター設定
    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      rust = { "clippy" },
    }

    -- ESLint設定
    lint.linters.eslint = require("lint.linters.eslint")

    -- リントを実行する関数
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- 保存時にリント実行
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Insert モードを抜けた時にリント実行
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- 手動リント用キーマップ
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "LSP: リント実行 (ESLint)" })
  end,
}
