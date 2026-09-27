-- ec (easy-conflict): terminal-native 3-way git mergetool
-- https://github.com/chojs23/ec
-- バイナリ本体は nix (home.packages の ec) で PATH に入る前提
return {
  "chojs23/ec",
  cmd = { "Ec" },
  keys = {
    { "<leader>gc", "<cmd>Ec<cr>", desc = "Git: Resolve conflicts (ec)" },
  },
  opts = {
    -- デフォルト: フローティングウィンドウで開く
    float = true,
    close_on_exit = true,
  },
}
