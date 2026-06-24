{ config, lib, ... }: {
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
