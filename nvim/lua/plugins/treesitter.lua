local ts_opts = {
    ensure_installed = { 
        "java", 
        "rust",          -- Rust用
        "typescript",    -- TypeScript用
        "tsx",           -- React/TSX用
        "lua", 
        "vim", 
        "vimdoc", 
        "query", 
        "markdown", 
        "markdown_inline",
        "bash",
        "json"
    },
    
    auto_install = true,

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
    build = ":TSUpdate",
}

M.config = function()
    require("nvim-treesitter").setup(ts_opts)
end

return M
