# config/ 以下の設定ファイルを out-of-store symlink で配置する（編集は rebuild なしで即反映）
{ config, host, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${host.dotfilesPath}/config/${path}";
in {
  xdg.configFile = {
    "nvim".source = link "nvim";
    "wezterm".source = link "wezterm";
    "aerospace/aerospace.toml".source = link "aerospace/aerospace.toml";
    "borders/bordersrc".source = link "borders/bordersrc";
    "herdr/config.toml".source = link "herdr/config.toml";
    "starship.toml".source = link "starship/starship.toml";
  };
}
