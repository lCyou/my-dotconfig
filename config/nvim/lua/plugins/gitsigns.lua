return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,  -- 記号を表示
        numhl      = false, -- 行番号のハイライトはオフ
        linehl     = false, -- 行全体のハイライトはオフ
        word_diff  = false, -- 単語単位の差分はオフ
        
        current_line_blame = false, -- 自動blame表示はオフ（キーマップで手動表示）
        
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          -- キーマッピング
          vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Git: Preview hunk' })
          vim.keymap.set('n', '<leader>gb', function() gs.blame_line({full=true}) end, { buffer = bufnr, desc = 'Git: Blame line' })
          vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = 'Git: Diff this' })
        end
      })
    end,
  },
}
