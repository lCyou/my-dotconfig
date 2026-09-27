# my-dotconfig

nix-darwin + home-manager で macOS (M1 MacBook Air) の環境を管理するドットファイルリポジトリ。

- **Nix**: Determinate Nix (nix 2.34.6)

## セットアップ

```bash
# リポジトリをクローン
ghq get github.com/lCyou/my-dotconfig

# nix-darwin の設定ディレクトリとしてシンボリックリンクを作成
ln -sfn ~/ghq/github.com/lCyou/my-dotconfig ~/.config/nix-darwin

# 適用（初回・更新ともに同じコマンド。`nr` でも可）
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
```

## ディレクトリ構成

「Nix で何をインストール・有効化するか」は `nix/`、「各アプリの設定ファイル本体」は `config/`、
「マシン固有の値」は `hosts/` に置く。

```
my-dotconfig/
├── flake.nix                  # エントリポイント。nix-darwin + home-manager + nix-homebrew を統合
├── hosts/
│   └── lcyou-mac-air-m1.nix   # ユーザー名・ホスト名・system・リポジトリパス
│
├── nix/                       # Nix モジュール
│   ├── darwin/                # nix-darwin（システム全体）
│   │   ├── default.nix        #   基本設定（zsh 有効化、unfree 許可、ユーザー）
│   │   ├── launchd.nix        #   常駐プロセス（jankyborders）
│   │   └── homebrew.nix       #   Homebrew tap / cask（wezterm, aerospace）
│   └── home/                  # home-manager（ユーザー環境）
│       ├── default.nix        #   PATH・環境変数
│       ├── packages.nix       #   home.packages（CLI・言語・フォント）
│       ├── dotfiles.nix       #   config/ → ~/.config へのシンボリックリンク一覧
│       └── programs/          #   programs.*（設定込みで管理するツール）
│           ├── default.nix    #     fzf, zoxide, gh, tmux, starship, zsh
│           ├── git.nix        #     git + delta
│           └── neovim.nix     #     neovim + LSP/フォーマッター
│
└── config/                    # アプリ設定ファイル本体（Nix を知らなくても読める）
    ├── nvim/                  #   → ~/.config/nvim
    ├── wezterm/               #   → ~/.config/wezterm
    ├── aerospace/             #   → ~/.config/aerospace/aerospace.toml
    ├── borders/               #   → ~/.config/borders/bordersrc
    ├── herdr/                 #   → ~/.config/herdr/config.toml
    └── starship/              #   → ~/.config/starship.toml
```

## 設定ファイルの反映方式

`config/` 以下は `nix/home/dotfiles.nix` で **out-of-store symlink**（`mkOutOfStoreSymlink`）として配置する。
`~/.config/nvim` などはリポジトリ内のファイルを直接指すので、**編集は rebuild なしで即反映**される。
（rebuild が必要なのは、リンクを新しく追加・削除したときだけ）

git / gh / zsh などは `nix/home/programs/` の `programs.*` で設定ごと Nix が生成する。

### 新しいアプリの設定を追加するには

1. `config/<app>/` に設定ファイルを置く
2. `nix/home/dotfiles.nix` の `xdg.configFile` に 1 行追加
3. `darwin-rebuild switch`

## Neovim の Nix 統合

Nix の pre-built バイナリを使うことで、ビルドステップなしにプラグインが動作する。

| 項目 | 方法 |
|------|------|
| LSP サーバー / フォーマッター | `programs.neovim.extraPackages` で PATH に追加 |
| telescope-fzf-native | `extraWrapperArgs` で `TELESCOPE_FZF_NATIVE` 環境変数にストアパスを注入 |
| treesitter グラマー | `extraWrapperArgs` で `TREESITTER_GRAMMARS` 環境変数にストアパスを注入 |
| Java デバッガ / lombok | `JAVA_DEBUG_DIR` / `LOMBOK_JAR` 環境変数で注入 |

Lua 側では環境変数を読んで Nix ストアのパスを参照する（非 Nix 環境ではフォールバックして通常インストール）：

```lua
-- telescope.lua
dir = vim.env.TELESCOPE_FZF_NATIVE,
build = vim.env.TELESCOPE_FZF_NATIVE and false or "make",

-- treesitter.lua
dir = vim.env.TREESITTER_GRAMMARS,
auto_install = vim.env.TREESITTER_GRAMMARS == nil,
```

インストール済みパッケージの一覧は `nix/home/packages.nix` と `nix/darwin/homebrew.nix` を参照。
