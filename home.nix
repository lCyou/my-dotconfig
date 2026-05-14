{ pkgs, ... }: {
  home.username = "lcyou";
  home.homeDirectory = "/Users/lcyou";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    git
    bat eza fd ripgrep tree jq
    ghq lazygit gnused
    gcc cmake automake lua
    deno pnpm yarn maven dart terraform act
    supabase-cli switchaudio-osx sketchybar aerospace ngrok
    cloudflared docker colima
    nerd-fonts.hack
  ];

  programs.fzf.enable      = true;
  programs.zoxide.enable   = true;
  programs.gh.enable       = true;
  programs.starship.enable = true;
  programs.tmux.enable     = true;

  programs.neovim = {
    enable      = true;
    defaultEditor = true;
    withRuby    = false;
    withPython3 = false;
  };

  programs.zsh = {
    enable = true;
    plugins = [
      { name = "zsh-autosuggestions";     src = pkgs.zsh-autosuggestions; }
      { name = "zsh-syntax-highlighting"; src = pkgs.zsh-syntax-highlighting; }
    ];
  };
}
