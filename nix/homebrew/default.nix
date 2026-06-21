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
    brews = [
      # "example-formula"
    ];
    casks = [
      "aerospace"
      "wezterm"
    ];
  };
}
