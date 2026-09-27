{ pkgs, ... }: {
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
