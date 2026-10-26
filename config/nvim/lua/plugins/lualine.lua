local options = {
	theme = "auto",
	component_separators = {
		right = "",
		left = "",
	},
	section_separators = {
		rigth = "",
		left = "",
	},
	globalstatus = true,
}

local sections = {}

local inactive_sections = {}

local tabline = {}

local extensions = {}

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, 
    config = function()
      require("lualine").setup({
        options = options,
      })
    end,
  },
}
