{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name  = "lcyou";
      user.email = "chiro3.syoren@gmail.com";
      merge.conflictstyle = "diff3";
      diff.colorMoved     = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate     = true;
      line-numbers = true;
      syntax-theme = "GitHub";
      side-by-side = false;
    };
  };
}
