require('core')
require('keymap')
require('plugin')
require("config.lazy")

vim.opt.number = true         -- 行番号を表示 (nu)
vim.opt.relativenumber = true  -- 相対行番号を表示 (rnu)
vim.opt.cursorline = true -- cursor行をハイライト
vim.opt.cursorcolumn = true -- cursor列をハイライト
vim.opt.termguicolors = ture -- true color 対応
vim.opt.smartindent = true -- indent設定

vim.api.nvim_create_user_command(
    'InitLua',
    function()
        vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
    end,
    {}
)
