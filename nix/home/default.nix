{ config, lib, pkgs, ... }: {
  imports = [
    ./packages.nix
    ./programs.nix
  ];

  home.username = "lcyou";
  home.homeDirectory = "/Users/lcyou";
  home.stateVersion = "24.11";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.claude/bin"
    "$HOME/go/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    JAVA_HOME = "${pkgs.jdk21}";
    ZSH_AUTOSUGGESTIONS_PATH = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    ZSH_SYNTAX_HIGHLIGHTING_PATH = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
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

    $DRY_RUN_CMD ln -sfn \
      "${config.home.homeDirectory}/ghq/github.com/lCyou/my-dotconfig/aerospace/aerospace.toml" \
      "${config.home.homeDirectory}/.aerospace.toml"
  '';

  xdg.configFile."borders/bordersrc".source = ../../borders/bordersrc;
  xdg.configFile."starship.toml".source = ../../starship.toml;
}
