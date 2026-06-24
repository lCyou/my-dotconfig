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
      "nikitabobko/tap/aerospace"
      "wezterm"
    ];
  };
}
