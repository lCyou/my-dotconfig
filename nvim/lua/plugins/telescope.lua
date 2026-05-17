local telescope_opts = {
    defaults = {
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
        },
        path_display = { "smart" },
    },
}

local M = {
    "nvim-telescope/telescope.nvim",
    version = '*',
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            dir = vim.env.TELESCOPE_FZF_NATIVE,
            build = vim.env.TELESCOPE_FZF_NATIVE and false or "make",
        },
    },
}

M.config = function()
    local telescope = require("telescope")
    telescope.setup(telescope_opts)
    telescope.load_extension("fzf")
    
    -- キーマップ設定
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end

return M
