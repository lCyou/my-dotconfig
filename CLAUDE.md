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

> 層で分割: `hosts/`（マシン固有値）/ `nix/`（Nix モジュール）/ `config/`（アプリ設定の実体）。このセクションは実体に追従させること。

| パス | 管理方法 | 備考 |
|------|---------|------|
| `flake.nix` | nix-darwin エントリポイント | `herdr`（GitHub flake input）を含む。`hosts/*.nix` を読み込み `host` として specialArgs / extraSpecialArgs で配布。`home-manager.backupFileExtension = "hm-bak"` |
| `hosts/lcyou-mac-air-m1.nix` | ホスト固有値 | `hostname`, `system`, `user`, `homeDirectory`, `dotfilesPath`。ユーザー名やパスは直書きせずここを参照する |
| `nix/darwin/default.nix` | nix-darwin システム設定 | `nix.enable = false`（Determinate Nix が管理）。`launchd.nix` / `homebrew.nix` を import |
| `nix/darwin/launchd.nix` | `launchd.user.agents` | jankyborders をバックグラウンド起動 |
| `nix/darwin/homebrew.nix` | `nix-homebrew` + `homebrew` モジュール | Homebrew tap/cask の宣言的管理 |
| `nix/home/default.nix` | home-manager エントリ | `packages.nix` / `programs` / `dotfiles.nix` を import。PATH・環境変数 |
| `nix/home/packages.nix` | `home.packages` | CLI・開発ツール一式 + `herdr` パッケージ |
| `nix/home/programs/` | `programs.*` 設定 | `default.nix`（fzf, zoxide, gh, tmux, starship, zsh）、`git.nix`、`neovim.nix`。新ツールは `<name>.nix` を足して import |
| `nix/home/dotfiles.nix` | `xdg.configFile` + `mkOutOfStoreSymlink` | `config/` 以下を `~/.config` にリンク。リポジトリ内ファイルを直接指すので編集は即反映 |
| `config/nvim/` | → `~/.config/nvim` | `nix/home/programs/neovim.nix` で `xdg.configFile."nvim/init.lua".enable = lib.mkForce false` により home-manager 自身の init.lua 生成を無効化 |
| `config/wezterm/` | → `~/.config/wezterm` | `wezterm` 本体は `nix/darwin/homebrew.nix` の cask で管理 |
| `config/aerospace/aerospace.toml` | → `~/.config/aerospace/aerospace.toml` | 旧配置 `~/.aerospace.toml` が残っていると aerospace がエラーにするので削除すること |
| `config/borders/bordersrc` | → `~/.config/borders/bordersrc` | 起動自体は `nix/darwin/launchd.nix` が担当 |
| `config/herdr/config.toml` | → `~/.config/herdr/config.toml` | onboarding無効化・theme固定・CJK入力対応・sidebar複数行表示を設定済み |
| `config/starship/starship.toml` | → `~/.config/starship.toml` | |
| gh 設定 | `programs.gh.settings` で管理 | `hosts.yml` は nix 管理外 |

---

## 現在インストール済みのパッケージ（`nix/home/packages.nix` ほか）

### CLI ツール
`git`, `bat`, `eza`, `fd`, `ripgrep`, `tree`, `jq`, `ghq`, `lazygit`, `gnused`, `nr`（`darwin-rebuild switch` のラッパー）

### 開発ツール
`gcc`, `gnumake`, `cmake`, `automake`, `lua`, `go`, `nodejs`, `deno`, `pnpm`, `yarn`, `maven`, `dart`, `jdk21`, `gradle`, `terraform`, `act`

### インフラ / クラウド
`supabase-cli`, `cloudflared`, `docker`, `colima`, `ngrok`

### macOS GUI / ユーティリティ
`switchaudio-osx`（`home.packages`）、`jankyborders`（`nix/darwin/launchd.nix` の launchd agent 経由）、`aerospace`（Homebrew cask、`nix/darwin/homebrew.nix`。upstream不具合で一時無効化中）

### ターミナル / マルチプレクサ
`herdr`（`home.packages` + `config/herdr/config.toml`）、`wezterm`（Homebrew cask、`nix/darwin/homebrew.nix`）

### フォント
`nerd-fonts.hack`, `nerd-fonts.jetbrains-mono`

### programs（home-manager で設定込み管理）
`fzf`, `zoxide`, `gh`, `tmux`, `starship`, `neovim`, `zsh`（プラグイン: autosuggestions, syntax-highlighting）、
`git`（`nix/home/programs/git.nix`。user/email, merge.conflictstyle, diff.colorMoved を設定）、
`delta`（git用ページャ。`enableGitIntegration = true`）

---

## 既知の問題・未解決事項

### 1. UDEV Gothic NF フォントが未管理

`config/wezterm/wezterm.lua` で `UDEV Gothic NF` を使用しているが、
`nix/home/packages.nix` には `nerd-fonts.hack` と `nerd-fonts.jetbrains-mono` しかなく、
UDEV Gothic NF は nix 管理外（手動インストール or Homebrew と推測）。

### 2. zsh の設定が空

`~/.zshrc` は home-manager が生成したもの（nix store 内）のみで、
zsh 用の設定ファイルは無い。エイリアスや追加設定を `programs.zsh.initContent` で管理していない。
また `~/.zshrch`（タイポ）というファイルが存在する（nix管理外、手動で作られたもの）。

### 3. tmux 設定が空

`programs.tmux.enable = true` だが tmux の設定が何もない。

### 4. Rosetta 未インストール警告（nix設定側では直せない）

`sudo darwin-rebuild switch` で `Warning: The Intel Homebrew prefix has been set up, but Rosetta isn't installed yet.` が出る。`nix-homebrew.enableRosetta = true`（`nix/darwin/homebrew.nix`）はIntel用Homebrewプレフィックスを有効化するだけで、Rosetta 2本体のインストールは行わない。直すには一度だけ手動で `softwareupdate --install-rosetta --agree-to-license` を実行する必要がある（2026-09-08時点で未実行）。

### 5. `brew bundle --cleanup` 非推奨警告（nix-darwinのバージョン追従待ち）

`Warning: Calling the --cleanup switch is deprecated! There is no replacement.` が出る。原因はHomebrew CLI側が `brew bundle install --cleanup` を廃止し `--force-cleanup` に変更したのに対し、`flake.lock` で固定している nix-darwin (`8c62fba`, 2026-05-03) がまだ追従していないこと。上流は nix-darwin PR #1789（2026-06-17マージ）で対応済みだが、そのコミットを含む新しい nix-darwin (`4cff07d` 以降) は release branch チェックが厳格化されており、`nixpkgs-unstable` を使う現在の `flake.nix` の組み合わせだと `nix-darwin 26.11 with Nixpkgs 26.05` のミスマッチでビルドが失敗する（2026-09-08に `nix flake lock --update-input nix-darwin` で確認済み、要 revert）。nix-darwin と nixpkgs を対応するブランチに揃えて同時に上げるまでは、単なる警告として無害（ビルド自体は失敗しない）なので保留でよい。急ぐ場合の代替案として `homebrew.onActivation.cleanup = "none"` にすれば警告は消えるが、Brewfile外のcask/formulaを自動アンインストールする機能を失うトレードオフがある。

---

## 今後やるべきタスク

### 高優先度

- [ ] **aerospace caskの復活**: `nikitabobko/tap/aerospace` を `nix/darwin/homebrew.nix` で一時的に無効化中（2026-09-08）。原因は upstream (nikitabobko/homebrew-tap) 側の2026-09-06コミット `9ac0bfc "Migrate off the deprecated postflight ruby blocks"` で、`postflight_steps` 内の `#{version}` をプレースホルダー化し忘れたバグ（`undefined local variable or method 'version'` で `brew bundle` が失敗し `darwin-rebuild switch` が完了しない）。upstream修正を確認したら `casks` のコメントを解除する。
- [ ] **UDEV Gothic NF フォントの管理**: nix で管理できる場合は追加（`nerd-fonts.udev-gothic`など）、できなければ Homebrew Cask で管理

### 中優先度

- [ ] **zsh 設定の整備**: エイリアス・カスタム設定を `nix/home/programs/zsh.nix` の `programs.zsh.initContent` に移行、`~/.zshrch`（タイポファイル）を削除または整理
- [ ] **tmux 設定の追加**: `nix/home/programs/tmux.nix` で `programs.tmux` に設定を追加するか `config/tmux/` にファイルを置いて `dotfiles.nix` でリンク

### 低優先度 / 将来の拡張

- [ ] **macOS システム設定の追加**: `nix/darwin/` に `system.defaults` でキーボード・トラックパッド・Dock 設定を追加
- [ ] **gh hosts.yml の管理**: `~/.config/gh/hosts.yml` を nix で管理（認証トークンを含むため secrets 管理が必要）

---

## よく使うコマンド

```bash
# 設定を適用
darwin-rebuild switch --flake ~/.config/nix-darwin

# dry-run で確認（sudo不要、評価・ビルドエラーの検出に使える）
darwin-rebuild build --flake ~/.config/nix-darwin
```

> home-manager は `flake.nix` で nix-darwin のモジュールとして組み込まれており、
> スタンドアロンの `home-manager` コマンドは存在しない（`command not found`）。
> home-manager 管理下の設定（`nix/home/`）だけを変更した場合も、反映には
> `darwin-rebuild switch` の実行が必要。
