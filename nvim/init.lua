-- leader key
vim.g.mapleader = " "

require('core')
require('keymap')
require('plugin')
require('keylogger')
require("config.lazy")

vim.opt.guicursor = "a:block" -- cursorをブロック表示にする
vim.opt.number = true         -- 行番号を表示 (nu)
vim.opt.relativenumber = true  -- 相対行番号を表示 (rnu)
vim.opt.signcolumn = "yes"     -- サインカラムを常時表示（Git差分記号用、幅固定でガタつき防止）
vim.opt.cursorline = true -- cursor行をハイライト
vim.opt.cursorcolumn = true -- cursor列をハイライト
vim.opt.termguicolors = true -- true color 対応
vim.opt.smartindent = true -- indent設定

-- lualineとの重複のため削除
vim.opt.showmode = false

vim.api.nvim_create_user_command(
    'InitLua',
    function()
        vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
    end,
    {}
)
