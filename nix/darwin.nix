{ pkgs, ... }: {
  nix.enable = false;

  programs.zsh.enable = true;
  system.stateVersion = 5;
  system.primaryUser = "lcyou";

  nixpkgs.config.allowUnfree = true;

  users.users.lcyou = {
    name = "lcyou";
    home = "/Users/lcyou";
  };

  launchd.user.agents.jankyborders = {
    serviceConfig = {
      Label = "jankyborders";
      ProgramArguments = [ "${pkgs.jankyborders}/bin/borders" ];
      EnvironmentVariables = {
        PATH = "${pkgs.jankyborders}/bin:/usr/bin:/bin";
      };
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/jankyborders.log";
      StandardErrorPath = "/tmp/jankyborders.log";
    };
  };
}
