return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, 
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        transparent = true,
        background = {
          dark = "dragon",
          light = "lotus"
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
