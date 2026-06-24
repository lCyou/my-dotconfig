{ pkgs, herdr, ... }:
let
  nr = pkgs.writeShellScriptBin "nr" ''
    exec darwin-rebuild switch --flake ~/.config/nix-darwin "$@"
  '';
in {
  home.packages = with pkgs; [
    nr

    # CLI
    git bat eza fd ripgrep tree jq
    ghq lazygit gnused

    # Build tools
    gcc gnumake cmake automake lua

    # Languages / runtimes
    go nodejs deno pnpm yarn maven dart
    jdk21 gradle terraform act

    # Cloud / infra
    supabase-cli cloudflared docker colima ngrok

    # macOS utilities
    switchaudio-osx

    # Fonts
    nerd-fonts.hack nerd-fonts.jetbrains-mono

    # External flakes
    herdr.packages.aarch64-darwin.default
  ];
}
