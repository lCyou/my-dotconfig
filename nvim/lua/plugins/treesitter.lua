local nix_grammars = vim.env.TREESITTER_GRAMMARS

local ts_opts = {
    auto_install = nix_grammars == nil,
    ensure_installed = nix_grammars and {} or {
        "java", "rust", "typescript", "tsx",
        "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline", "bash", "json"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
}

local M = {
    "nvim-treesitter/nvim-treesitter",
    dir = nix_grammars,
    build = nix_grammars and false or ":TSUpdate",
}

M.config = function()
    require("nvim-treesitter").setup(ts_opts)
end

return M
