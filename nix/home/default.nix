{ pkgs, ... }: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./dotfiles.nix
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
  };
}
