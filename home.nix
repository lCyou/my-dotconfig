{ config, lib, pkgs, ... }: {
  home.username = "lcyou";
  home.homeDirectory = "/Users/lcyou";
  home.stateVersion = "24.11";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.claude/bin"
  ];

  home.packages = with pkgs; [
    git
    bat eza fd ripgrep tree jq
    ghq lazygit gnused
    gcc gnumake cmake automake lua
    deno pnpm yarn maven dart terraform act
    supabase-cli switchaudio-osx sketchybar aerospace ngrok
    cloudflared docker colima
    wezterm
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    pkgs.jankyborders
  ];

  programs.neovim = {
    enable = true;
    extraWrapperArgs = [
      "--set" "TELESCOPE_FZF_NATIVE"
      "${pkgs.vimPlugins.telescope-fzf-native-nvim}"
      "--set" "TREESITTER_GRAMMARS"
      "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}"
    ];
    extraPackages = with pkgs; [
      typescript-language-server
      rust-analyzer
      prettier
      stylua
    ];
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.fzf.enable    = true;
  programs.zoxide.enable = true;
  programs.gh.enable     = true;
  programs.tmux.enable   = true;

  programs.starship = {
    enable   = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.zsh = {
    enable = true;
    plugins = [
      { name = "zsh-autosuggestions";     src = pkgs.zsh-autosuggestions; }
      { name = "zsh-syntax-highlighting"; src = pkgs.zsh-syntax-highlighting; }
    ];
  };

  home.activation.dotfileLinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -rf "${config.xdg.configHome}/nvim"
    $DRY_RUN_CMD ln -sfn \
      "${config.home.homeDirectory}/ghq/github.com/lCyou/my-dotconfig/nvim" \
      "${config.xdg.configHome}/nvim"

    rm -rf "${config.xdg.configHome}/wezterm"
    $DRY_RUN_CMD ln -sfn \
      "${config.home.homeDirectory}/ghq/github.com/lCyou/my-dotconfig/wezterm" \
      "${config.xdg.configHome}/wezterm"
  '';

  # aerospace は ~/.aerospace.toml を参照 (読み取り専用で問題なし)
  home.file.".aerospace.toml".source = ./aerospace/aerospace.toml;

  # borders (読み取り専用で問題なし)
  xdg.configFile."borders/bordersrc".source = ./borders/bordersrc;
}
