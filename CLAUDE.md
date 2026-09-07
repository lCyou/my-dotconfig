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

> `home.nix` 単一ファイル構成から `nix/` 配下への分割構成に移行済み（このセクションは実体に追従させること）。

| パス | 管理方法 | 備考 |
|------|---------|------|
| `flake.nix` | nix-darwin エントリポイント | `herdr`（GitHub flake input）を含む。ルートの flake が現在の有効設定 |
| `nix/darwin.nix` | nix-darwin システム設定 | `nix.enable = false`（Determinate Nix が管理）。`launchd.user.agents.jankyborders` で jankyborders をバックグラウンド起動 |
| `nix/home/default.nix` | home-manager エントリ | `packages.nix` / `programs.nix` / `dotfiles.nix` を import |
| `nix/home/packages.nix` | `home.packages` | CLI・開発ツール一式 + `herdr` パッケージ |
| `nix/home/programs.nix`, `nix/home/programs/*.nix` | `programs.*` 設定 | fzf, zoxide, gh, tmux, starship, zsh, neovim, git |
| `nix/home/dotfiles.nix` | `home.activation` + `xdg.configFile` | nvim/wezterm/aerospace のシンボリックリンク、borders/starship/herdr の configFile 配置 |
| `nix/homebrew/default.nix` | `nix-homebrew` + `homebrew` モジュール | Homebrew tap/cask の宣言的管理（下記参照）|
| `nix-darwin/` | **旧設定（未使用）** | ホスト名 `lCyouMac`、ユーザー `kyou` の旧設定。整理未着手 |
| `aerospace/aerospace.toml` | `home.activation` でシンボリックリンク配置 | 動作確認済み |
| `borders/bordersrc` | `xdg.configFile` で `~/.config/borders/bordersrc` に配置 | 起動自体は `nix/darwin.nix` の launchd agent が担当 |
| `nvim/` | `home.activation` で `rm -rf` 後にシンボリックリンク | `~/.config/nvim` 自体がリンクになっている。加えて `nix/home/programs/neovim.nix` で `xdg.configFile."nvim/init.lua".enable = lib.mkForce false` により home-manager 自身の init.lua 生成を無効化 |
| `wezterm/` | `home.activation` でシンボリックリンク | 設定ファイルは動作確認済み。`wezterm` 本体は home.packages ではなく `nix/homebrew` の cask で管理 |
| `herdr/config.toml` | `xdg.configFile` で `~/.config/herdr/config.toml` に配置 | ターミナルワークスペースマネージャ herdr の設定。onboarding無効化・theme固定・CJK入力対応・sidebar複数行表示を設定済み |
| `starship.toml` | `xdg.configFile` | `~/.config/starship.toml` にシンボリックリンク済み |
| `gh/config.yml` | `programs.gh.enable` で管理 | `hosts.yml` は nix 管理外 |
| `configstore/` | nix 管理外 | 各 CLI ツールの自動生成ファイル |
| `starship/`, `tmux/`, `zsh/` | 空ディレクトリ | 将来の設定ファイル置き場として存在 |

---

## 現在インストール済みのパッケージ（`nix/home/packages.nix` ほか）

### CLI ツール
`git`, `bat`, `eza`, `fd`, `ripgrep`, `tree`, `jq`, `ghq`, `lazygit`, `gnused`, `nr`（`darwin-rebuild switch` のラッパー）

### 開発ツール
`gcc`, `gnumake`, `cmake`, `automake`, `lua`, `go`, `nodejs`, `deno`, `pnpm`, `yarn`, `maven`, `dart`, `jdk21`, `gradle`, `terraform`, `act`

### インフラ / クラウド
`supabase-cli`, `cloudflared`, `docker`, `colima`, `ngrok`

### macOS GUI / ユーティリティ
`switchaudio-osx`（`home.packages`）、`jankyborders`（`nix/darwin.nix` の launchd agent 経由）、`aerospace`（Homebrew cask、`nix/homebrew`。upstream不具合で一時無効化中）

### ターミナル / マルチプレクサ
`herdr`（`home.packages` + `herdr/config.toml`）、`wezterm`（Homebrew cask、`nix/homebrew`）

### フォント
`nerd-fonts.hack`, `nerd-fonts.jetbrains-mono`

### programs（home-manager で設定込み管理）
`fzf`, `zoxide`, `gh`, `tmux`, `starship`, `neovim`, `zsh`（プラグイン: autosuggestions, syntax-highlighting）、
`git`（`nix/home/programs/git.nix`。user/email, merge.conflictstyle, diff.colorMoved を設定）、
`delta`（git用ページャ。`enableGitIntegration = true`）

---

## 既知の問題・未解決事項

### 1. UDEV Gothic NF フォントが未管理

`wezterm/wezterm.lua` で `UDEV Gothic NF` を使用しているが、
`nix/home/packages.nix` には `nerd-fonts.hack` と `nerd-fonts.jetbrains-mono` しかなく、
UDEV Gothic NF は nix 管理外（手動インストール or Homebrew と推測）。

### 2. zsh の設定が空

`~/.zshrc` は home-manager が生成したもの（nix store 内）のみで、
`zsh/` ディレクトリは空。エイリアスや追加設定を `programs.zsh.initContent` で管理していない。
また `~/.zshrch`（タイポ）というファイルが存在する（nix管理外、手動で作られたもの）。

### 3. tmux 設定が空

`programs.tmux.enable = true` だが `tmux/` ディレクトリは空で、tmux の設定が何もない。

### 4. 旧設定ディレクトリが残存

`nix-darwin/` ディレクトリは旧設定（ユーザー `kyou`、ホスト `lCyouMac`）。
現在は使われていないが、混乱の原因になる可能性がある。

### 5. Rosetta 未インストール警告（nix設定側では直せない）

`sudo darwin-rebuild switch` で `Warning: The Intel Homebrew prefix has been set up, but Rosetta isn't installed yet.` が出る。`nix-homebrew.enableRosetta = true`（`nix/homebrew/default.nix`）はIntel用Homebrewプレフィックスを有効化するだけで、Rosetta 2本体のインストールは行わない。直すには一度だけ手動で `softwareupdate --install-rosetta --agree-to-license` を実行する必要がある（2026-09-08時点で未実行）。

### 6. `brew bundle --cleanup` 非推奨警告（nix-darwinのバージョン追従待ち）

`Warning: Calling the --cleanup switch is deprecated! There is no replacement.` が出る。原因はHomebrew CLI側が `brew bundle install --cleanup` を廃止し `--force-cleanup` に変更したのに対し、`flake.lock` で固定している nix-darwin (`8c62fba`, 2026-05-03) がまだ追従していないこと。上流は nix-darwin PR #1789（2026-06-17マージ）で対応済みだが、そのコミットを含む新しい nix-darwin (`4cff07d` 以降) は release branch チェックが厳格化されており、`nixpkgs-unstable` を使う現在の `flake.nix` の組み合わせだと `nix-darwin 26.11 with Nixpkgs 26.05` のミスマッチでビルドが失敗する（2026-09-08に `nix flake lock --update-input nix-darwin` で確認済み、要 revert）。nix-darwin と nixpkgs を対応するブランチに揃えて同時に上げるまでは、単なる警告として無害（ビルド自体は失敗しない）なので保留でよい。急ぐ場合の代替案として `homebrew.onActivation.cleanup = "none"` にすれば警告は消えるが、Brewfile外のcask/formulaを自動アンインストールする機能を失うトレードオフがある。

---

## 今後やるべきタスク

### 高優先度

- [ ] **aerospace caskの復活**: `nikitabobko/tap/aerospace` を `nix/homebrew/default.nix` で一時的に無効化中（2026-09-08）。原因は upstream (nikitabobko/homebrew-tap) 側の2026-09-06コミット `9ac0bfc "Migrate off the deprecated postflight ruby blocks"` で、`postflight_steps` 内の `#{version}` をプレースホルダー化し忘れたバグ（`undefined local variable or method 'version'` で `brew bundle` が失敗し `darwin-rebuild switch` が完了しない）。upstream修正を確認したら `casks` のコメントを解除する。
- [ ] **UDEV Gothic NF フォントの管理**: nix で管理できる場合は追加（`nerd-fonts.udev-gothic`など）、できなければ Homebrew Cask で管理

### 中優先度

- [ ] **zsh 設定の整備**: エイリアス・カスタム設定を `programs.zsh.initContent` に移行、`~/.zshrch`（タイポファイル）を削除または整理
- [ ] **tmux 設定の追加**: `programs.tmux` に設定を追加するか `tmux/` にファイルを置いて home-manager で管理
- [ ] **旧設定 `nix-darwin/` の整理**: 参照用に残すか削除するか決める

### 低優先度 / 将来の拡張

- [ ] **macOS システム設定の追加**: `darwin.nix` に `system.defaults` でキーボード・トラックパッド・Dock 設定を追加
- [ ] **gh hosts.yml の管理**: `~/.config/gh/hosts.yml` を nix で管理（認証トークンを含むため secrets 管理が必要）
- [ ] **configstore/ の整理**: gitignore するか nix で管理するか決める

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
