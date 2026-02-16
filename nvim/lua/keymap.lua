local keymap = vim.keymap

-- タブ操作
keymap.set('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true, desc = '次のタブへ移動' })
keymap.set('n', '<S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true, desc = '前のタブへ移動' })
keymap.set('n', '<leader>w', ':tabclose<CR>', { noremap = true, silent = true, desc = 'タブを閉じる' })
keymap.set('n', '<leader>t', ':tabnew<CR>', { noremap = true, silent = true, desc = '新しいタブを開く' })

-- 代替キーマップ（数字でタブ移動）
keymap.set('n', '<leader>1', '1gt', { noremap = true, silent = true, desc = 'タブ1へ移動' })
keymap.set('n', '<leader>2', '2gt', { noremap = true, silent = true, desc = 'タブ2へ移動' })
keymap.set('n', '<leader>3', '3gt', { noremap = true, silent = true, desc = 'タブ3へ移動' })
keymap.set('n', '<leader>4', '4gt', { noremap = true, silent = true, desc = 'タブ4へ移動' })
keymap.set('n', '<leader>5', '5gt', { noremap = true, silent = true, desc = 'タブ5へ移動' })
