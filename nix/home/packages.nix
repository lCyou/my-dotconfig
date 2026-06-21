{ pkgs, ... }:
let
  nr = pkgs.writeShellScriptBin "nr" ''
    exec darwin-rebuild switch --flake ~/.config/nix-darwin "$@"
  '';
in {
  home.packages = with pkgs; [
    nr
    git
    bat eza fd ripgrep tree jq
    ghq lazygit gnused
    gcc gnumake cmake automake lua
    go
    nodejs deno pnpm yarn maven dart terraform act
    jdk21 gradle
    supabase-cli switchaudio-osx ngrok
    cloudflared docker colima
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    pkgs.jankyborders
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
