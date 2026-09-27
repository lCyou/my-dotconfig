local keymap = vim.keymap

-- タブ操作
-- gt/gT (Vimデフォルト) を使用
-- 数字指定: 1gt, 2gt, 3gt... (Vimデフォルト)
keymap.set('n', '<leader>w', ':tabclose<CR>', { noremap = true, silent = true, desc = 'タブを閉じる' })
keymap.set('n', '<leader>t', ':tabnew<CR>', { noremap = true, silent = true, desc = '新しいタブを開く' })
