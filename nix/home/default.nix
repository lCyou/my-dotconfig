{ pkgs, host, ... }: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./dotfiles.nix
  ];

  home.username = host.user;
  home.homeDirectory = host.homeDirectory;
  home.stateVersion = "24.11";
  manual.manpages.enable = false;

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
