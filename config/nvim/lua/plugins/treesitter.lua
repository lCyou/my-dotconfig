local nix_grammars = vim.env.TREESITTER_GRAMMARS
-- Only treat the Nix path as valid when compiled parsers are actually present
local has_nix_parsers = nix_grammars ~= nil
    and vim.fn.isdirectory(nix_grammars .. "/parser") == 1

local ts_opts = {
    auto_install = not has_nix_parsers,
    ensure_installed = has_nix_parsers and {} or {
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
    dir = has_nix_parsers and nix_grammars or nil,
    build = has_nix_parsers and false or ":TSUpdate",
}

M.config = function()
    require("nvim-treesitter").setup(ts_opts)
end

return M
