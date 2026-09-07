{ ... }: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "lcyou";
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = false;
      upgrade = false;
    };
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      # "example-formula"
    ];
    casks = [
      # "nikitabobko/tap/aerospace" # 一時的に無効化。TODO参照
      "wezterm"
    ];
  };
}
