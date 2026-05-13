{ pkgs, ... }: {
  home.username = "kyou";
  home.homeDirectory = "/Users/kyou";
  home.stateVersion = "24.11";

  # ── Phase 1: CLI ツール ──────────────────────────────────────────────
  home.packages = with pkgs; [
    # CLI
    bat
    eza
    fd
    ripgrep
    tree
    jq
    lazygit
    ghq
    gnused

    # 開発ツール
    cmake
    automake
    gcc
    llvm
    lua
    deno
    pnpm
    yarn
    maven
    terraform
    dart
    supabase-cli
    act
    qemu
    zeromq
    swi-prolog

    # フォント・端末
    # wezterm は stable 版 (cask の @nightly とは異なる)
    wezterm
    nerd-fonts.hack
  ];

  # ── home-manager で設定まで管理するツール ───────────────────────────
  # fzf / zoxide: .zshrc に既存 init があるため shell integration は無効
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };

  # starship: .zshrc の eval はそのまま使い、バイナリのみ管理
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    # settings はここに書けば starship.toml を置き換えられる
    # 今は既存の ~/.config/starship.toml をそのまま使う
  };

  programs.gh.enable = true;

  programs.tmux.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
    # ~/.config/nvim は既存設定をそのまま使用
  };
}
