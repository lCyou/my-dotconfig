return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 200  -- 200ms後にポップアップ表示
  end,
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      preset = "modern",
      delay = 200,
      
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      
      layout = {
        spacing = 3,
        align = "left",
      },
      
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      
      -- ビルトインマッピングを表示
      spec = {
        { "g", group = "goto" },
        { "gt", desc = "Go to next tab" },
        { "gT", desc = "Go to previous tab" },
        { "z", group = "fold" },
        { "]", group = "next" },
        { "[", group = "prev" },
        { "<leader>", group = "leader" },
        
        -- Leaderキーのグループ定義
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>ln", desc = "LSP: Rename" },
        { "<leader>la", desc = "LSP: Code Action" },
        { "<leader>lf", desc = "LSP: Format (Prettier)" },
        { "<leader>lo", desc = "LSP: Organize Imports" },
        { "<leader>ll", desc = "LSP: Lint (ESLint)" },
        { "<leader>e", desc = "Explorer (NeoTree)" },
        { "<leader>t", desc = "Tab: New" },
        { "<leader>w", desc = "Tab: Close" },
      },
    })
  end,
}
