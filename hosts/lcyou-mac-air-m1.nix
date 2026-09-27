# ホスト固有の値。各モジュールには specialArgs / extraSpecialArgs の `host` として渡る
rec {
  hostname = "lcyou-mac-air-m1";
  system = "aarch64-darwin";
  user = "lcyou";
  homeDirectory = "/Users/${user}";
  dotfilesPath = "${homeDirectory}/ghq/github.com/lCyou/my-dotconfig";
}
