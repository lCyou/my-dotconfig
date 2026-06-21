# my-dotconfig — Nix 管理ドキュメント

## リポジトリ概要

nix-darwin + home-manager で macOS (M1 MacBook Air) の環境を管理するリポジトリ。

- **ホスト名**: `lcyou-mac-air-m1`
- **ユーザー**: `lcyou`
- **Nix**: Determinate Nix 3.20.0 (nix 2.34.6)
- **適用コマンド**: `darwin-rebuild switch --flake ~/.config/nix-darwin`

> `~/.config/nix-darwin` は `~/ghq/github.com/lCyou/my-dotconfig` へのシンボリックリンク。

---

## ディレクトリ構成と各設定の役割

| パス | 管理方法 | 備考 |
|------|---------|------|
| `flake.nix` | nix-darwin エントリポイント | ルートの flake が現在の有効設定 |
| `darwin.nix` | nix-darwin システム設定 | `nix.enable = false`（Determinate Nix が管理）|
| `home.nix` | home-manager 設定 | パッケージ・プログラム・シンボリックリンク管理 |
| `nix-darwin/` | **旧設定（未使用）** | ホスト名 `lCyouMac`、ユーザー `kyou` の旧設定 |
| `aerospace/aerospace.toml` | `home.file` で `~/.aerospace.toml` に配置 | 動作確認済み |
| `borders/bordersrc` | `xdg.configFile` で `~/.config/borders/bordersrc` に配置 | 動作確認済み |
| `nvim/` | activation script でシンボリックリンク | **問題あり（後述）** |
| `wezterm/` | activation script でシンボリックリンク | 動作確認済み |
| `starship.toml` | `programs.starship.settings` で読み込み | `~/.config/starship.toml` にシンボリックリンク済み |
| `gh/config.yml` | `programs.gh.enable` で管理 | `hosts.yml` は nix 管理外 |
| `configstore/` | nix 管理外 | 各 CLI ツールの自動生成ファイル |
| `starship/`, `tmux/`, `zsh/` | 空ディレクトリ | 将来の設定ファイル置き場として存在 |

---

## 現在インストール済みのパッケージ（home.nix）

### CLI ツール
`git`, `bat`, `eza`, `fd`, `ripgrep`, `tree`, `jq`, `ghq`, `lazygit`, `gnused`

### 開発ツール
`gcc`, `cmake`, `automake`, `lua`, `deno`, `pnpm`, `yarn`, `maven`, `dart`, `terraform`, `act`

### インフラ / クラウド
`supabase-cli`, `cloudflared`, `docker`, `colima`, `ngrok`

### macOS GUI / ユーティリティ
`switchaudio-osx`, `sketchybar`, `aerospace`, `pkgs.jankyborders`

### フォント
`nerd-fonts.hack`, `nerd-fonts.jetbrains-mono`

### programs（home-manager で設定込み管理）
`fzf`, `zoxide`, `gh`, `tmux`, `starship`, `neovim`, `zsh`（プラグイン: autosuggestions, syntax-highlighting）

---

## 設定が反映されていない原因

### 1. nvim シンボリックリンクの競合（重要）

`home.nix` の activation script で `ln -sfn .../nvim ~/.config/nvim` を実行しているが、
home-manager が先に `~/.config/nvim/` ディレクトリを作成し `init.lua` を配置するため、
`ln -sfn` がディレクトリ内にシンボリックリンクを作ってしまっている。

**現状の実際のファイル構成**:
```
~/.config/nvim/
  init.lua -> /nix/store/.../init.lua  (home-manager が生成した stub)
  nvim/    -> ~/ghq/.../nvim           (activation script が誤配置したリンク)
```

**本来あるべき構成**: `~/.config/nvim` 自体が `~/ghq/.../nvim` へのシンボリックリンク

**修正方法**:
```nix
home.activation.nvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
  rm -rf "${config.xdg.configHome}/nvim"
  $DRY_RUN_CMD ln -sfn \
    "${config.home.homeDirectory}/ghq/github.com/lCyou/my-dotconfig/nvim" \
    "${config.xdg.configHome}/nvim"
'';
```

### 2. WezTerm が nix 管理外

`wezterm` バイナリが PATH に存在しない（`which wezterm` で not found）。
現在は Homebrew Cask の `/Applications/WezTerm.app` が使われている。
`home.nix` に `wezterm` パッケージは含まれていない（旧 `nix-darwin/home.nix` には含まれていた）。

### 3. UDEV Gothic NF フォントが未管理

`wezterm/wezterm.lua` で `UDEV Gothic NF` を使用しているが、
`home.nix` には `nerd-fonts.hack` と `nerd-fonts.jetbrains-mono` しかなく、
UDEV Gothic NF は nix 管理外（手動インストール or Homebrew と推測）。

### 4. zsh の設定が空

`~/.zshrc` は home-manager が生成したもの（nix store 内）のみで、
`zsh/` ディレクトリは空。エイリアスや追加設定を `programs.zsh.initContent` で管理していない。
また `~/.zshrch`（タイポ？）に `# zshrc` とだけ書かれたファイルが存在する。

### 5. tmux 設定が空

`programs.tmux.enable = true` だが `tmux/` ディレクトリは空で、tmux の設定が何もない。

### 6. sketchybar 設定が未管理

`sketchybar` バイナリはインストール済みだが、設定ファイルが存在しない。

### 7. 旧設定ディレクトリが残存

`nix-darwin/` ディレクトリは旧設定（ユーザー `kyou`、ホスト `lCyouMac`）。
現在は使われていないが、混乱の原因になる可能性がある。

---

## 今後やるべきタスク

### 高優先度

- [ ] **nvim シンボリックリンクの修正**: activation script に `rm -rf` を追加して `~/.config/nvim` を正しくシンボリックリンクに変更する
- [ ] **WezTerm を nix 管理に移行**: `home.packages` に `wezterm` を追加、または Homebrew Cask のままにするか方針を決める
- [ ] **UDEV Gothic NF フォントの管理**: nix で管理できる場合は追加（`nerd-fonts.udev-gothic`など）、できなければ Homebrew Cask で管理

### 中優先度

- [ ] **zsh 設定の整備**: エイリアス・カスタム設定を `programs.zsh.initContent` に移行、`~/.zshrch`（タイポファイル）を削除または整理
- [ ] **tmux 設定の追加**: `programs.tmux` に設定を追加するか `tmux/` にファイルを置いて home-manager で管理
- [ ] **sketchybar 設定の追加**: 設定ファイルを作成して `xdg.configFile` で管理
- [ ] **旧設定 `nix-darwin/` の整理**: 参照用に残すか削除するか決める

### 低優先度 / 将来の拡張

- [ ] **macOS システム設定の追加**: `darwin.nix` に `system.defaults` でキーボード・トラックパッド・Dock 設定を追加
- [ ] **Homebrew の nix 管理**: `nix-darwin` の `homebrew` モジュールで `brew install` / `brew install --cask` を宣言的に管理
- [ ] **gh hosts.yml の管理**: `~/.config/gh/hosts.yml` を nix で管理（認証トークンを含むため secrets 管理が必要）
- [ ] **configstore/ の整理**: gitignore するか nix で管理するか決める

---

## よく使うコマンド

```bash
# 設定を適用
darwin-rebuild switch --flake ~/.config/nix-darwin

# dry-run で確認
darwin-rebuild build --flake ~/.config/nix-darwin

# home-manager のみ再適用（nix-darwin なしで単体実行）
home-manager switch --flake ~/.config/nix-darwin
```
