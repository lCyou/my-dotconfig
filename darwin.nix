{ pkgs, ... }: {
  nix.enable = false;

  programs.zsh.enable = true;
  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;

  users.users.lcyou = {
    name = "lcyou";
    home = "/Users/lcyou";
  };
}
