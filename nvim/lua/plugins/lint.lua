return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      rust = { "clippy" },
    }

    lint.linters.eslint = require("lint.linters.eslint")
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local function try_lint_safe()
      local linters = lint.linters_by_ft[vim.bo.filetype] or {}
      local available = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then return false end
        local cmd = linter.cmd
        return vim.fn.executable(cmd) == 1
          or vim.fn.findfile("node_modules/.bin/" .. cmd, ".;") ~= ""
      end, linters)
      if #available > 0 then
        lint.try_lint(available)
      end
    end

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = try_lint_safe,
    })

    -- Insert モードを抜けた時にリント実行
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
      group = lint_augroup,
      callback = try_lint_safe,
    })

    -- 手動リント用キーマップ
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "LSP: リント実行 (ESLint)" })
  end,
}
