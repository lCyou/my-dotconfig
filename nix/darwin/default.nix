{ host, ... }: {
  imports = [
    ./launchd.nix
    ./homebrew.nix
  ];

  nix.enable = false;
  documentation.man.enable = false;

  programs.zsh.enable = true;
  system.stateVersion = 5;
  system.primaryUser = host.user;

  nixpkgs.config.allowUnfree = true;

  users.users.${host.user} = {
    name = host.user;
    home = host.homeDirectory;
  };
}
