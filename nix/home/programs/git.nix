{ ... }: {
  programs.git = {
    enable = true;
    userName  = "lcyou";
    userEmail = "chiro3.syoren@gmail.com";

    delta = {
      enable = true;
      options = {
        navigate    = true;
        line-numbers = true;
        syntax-theme = "GitHub";
        side-by-side = false;
      };
    };

    extraConfig = {
      merge.conflictstyle = "diff3";
      diff.colorMoved     = "default";
      interactive.diffFilter = "delta --color-only";
    };
  };
}
