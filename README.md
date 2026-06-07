# my-dotconfig

nix-darwin + home-manager で macOS (M1 MacBook Air) の環境を管理するドットファイルリポジトリ。

- **Nix**: Determinate Nix (nix 2.34.6)

## セットアップ

```bash
# リポジトリをクローン
ghq get github.com/lCyou/my-dotconfig

# nix-darwin の設定ディレクトリとしてシンボリックリンクを作成
ln -sfn ~/ghq/github.com/lCyou/my-dotconfig ~/.config/nix-darwin

# 適用（初回・更新ともに同じコマンド）
darwin-rebuild switch --flake ~/.config/nix-darwin
```

## ディレクトリ構成

```
my-dotconfig/
├── flake.nix          # エントリポイント。nix-darwin + home-manager を統合
├── darwin.nix         # nix-darwin システム設定（zsh有効化、unfree許可など）
├── home.nix           # home-manager 設定（パッケージ・プログラム・シンボリックリンク）
│
├── nvim/              # Neovim 設定 → darwin-rebuild で ~/.config/nvim にシンボリックリンク
│   ├── init.lua
│   └── lua/
│       ├── config/
│       │   └── lazy.lua       # lazy.nvim の初期化
│       ├── core.lua
│       ├── keymap.lua
│       ├── plugin.lua
│       └── plugins/
│           ├── cmp.lua        # 補完 (nvim-cmp + LuaSnip)
│           ├── colorscheme.lua
│           ├── conform.lua    # フォーマッター (prettier, stylua)
│           ├── dashboard.lua
│           ├── gitsigns.lua
│           ├── lazygit.lua
│           ├── lint.lua
│           ├── lsp.lua        # LSP (ts_ls, rust-analyzer)
│           ├── lualine.lua
│           ├── neotree.lua
│           ├── telescope.lua  # ファジーファインダー
│           ├── treesitter.lua # シンタックスハイライト
│           └── which-key.lua
│
├── wezterm/           # WezTerm 設定 → darwin-rebuild で ~/.config/wezterm にシンボリックリンク
│   ├── wezterm.lua
│   ├── keybinds.lua
│   ├── opacity.lua
│   └── statusbar.lua
│
├── aerospace/
│   └── aerospace.toml # ウィンドウマネージャ → ~/.aerospace.toml に配置
│
├── borders/
│   └── bordersrc      # ウィンドウボーダー → ~/.config/borders/bordersrc に配置
│
├── starship.toml      # プロンプト設定 (programs.starship で読み込み)
│
├── nix-darwin/        # 旧設定（未使用）
├── configstore/       # CLI ツールの自動生成ファイル（nix 管理外）
├── starship/          # 空ディレクトリ（将来用）
├── tmux/              # 空ディレクトリ（将来用）
└── zsh/               # 空ディレクトリ（将来用）
```

## Nix による管理の仕組み

### flake.nix

`nixpkgs-unstable` を使用。nix-darwin と home-manager を統合し、`darwinConfigurations."lcyou-mac-air-m1"` を定義する。

### darwin.nix

nix-darwin のシステム設定。Determinate Nix が nix デーモンを管理するため `nix.enable = false`。

### home.nix

home-manager の中心設定。主な役割：

| 設定 | 内容 |
|------|------|
| `home.packages` | CLI ツール・開発ツール・フォント群 |
| `programs.neovim` | Neovim 本体 + LSP/フォーマッター PATH 注入 |
| `programs.zsh` | zsh + autosuggestions + syntax-highlighting |
| `programs.starship` | starship プロンプト |
| `programs.fzf / zoxide / gh / tmux` | 各ツールの有効化 |
| `home.activation.dotfileLinks` | nvim・wezterm のシンボリックリンク作成 |
| `home.file / xdg.configFile` | aerospace・borders の設定ファイル配置 |

### Neovim の Nix 統合

Nix の pre-built バイナリを使うことで、ビルドステップなしにプラグインが動作する。

| 項目 | 方法 |
|------|------|
| LSP サーバー (ts_ls, rust-analyzer) | `programs.neovim.extraPackages` で PATH に追加 |
| フォーマッター (prettier, stylua) | 同上 |
| telescope-fzf-native | `extraWrapperArgs` で `TELESCOPE_FZF_NATIVE` 環境変数にストアパスを注入 |
| treesitter グラマー | `extraWrapperArgs` で `TREESITTER_GRAMMARS` 環境変数にストアパスを注入 |

Lua 側では環境変数を読んで Nix ストアのパスを参照する（非 Nix 環境ではフォールバックして通常インストール）：

```lua
-- telescope.lua
dir = vim.env.TELESCOPE_FZF_NATIVE,
build = vim.env.TELESCOPE_FZF_NATIVE and false or "make",

-- treesitter.lua
dir = vim.env.TREESITTER_GRAMMARS,
auto_install = vim.env.TREESITTER_GRAMMARS == nil,
```

## インストール済みパッケージ

| カテゴリ | パッケージ |
|---------|-----------|
| CLI | `bat` `eza` `fd` `ripgrep` `tree` `jq` `ghq` `lazygit` `gnused` |
| 開発 | `gcc` `gnumake` `cmake` `automake` `lua` `deno` `pnpm` `yarn` `maven` `dart` `terraform` `act` |
| インフラ | `supabase-cli` `cloudflared` `docker` `colima` `ngrok` |
| macOS | `switchaudio-osx` `sketchybar` `aerospace` `jankyborders` `wezterm` |
| フォント | `nerd-fonts.hack` `nerd-fonts.jetbrains-mono` |
| LSP/フォーマッター | `typescript-language-server` `rust-analyzer` `prettier` `stylua` |
