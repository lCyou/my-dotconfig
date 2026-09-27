{ config, lib, host, ... }: {
  home.activation.dotfileLinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -rf "${config.xdg.configHome}/nvim"
    $DRY_RUN_CMD ln -sfn \
      "${host.dotfilesPath}/nvim" \
      "${config.xdg.configHome}/nvim"

    rm -rf "${config.xdg.configHome}/wezterm"
    $DRY_RUN_CMD ln -sfn \
      "${host.dotfilesPath}/wezterm" \
      "${config.xdg.configHome}/wezterm"

    $DRY_RUN_CMD ln -sfn \
      "${host.dotfilesPath}/aerospace/aerospace.toml" \
      "${config.home.homeDirectory}/.aerospace.toml"
  '';

  xdg.configFile."borders/bordersrc".source = ../../borders/bordersrc;
  xdg.configFile."starship.toml".source = ../../starship.toml;
  xdg.configFile."herdr/config.toml".source = ../../herdr/config.toml;
}
