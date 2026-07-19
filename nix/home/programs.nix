{ ... }: {
  imports = [
    ./programs/neovim.nix
    ./programs/git.nix
  ];

  programs.fzf.enable     = true;
  programs.zoxide.enable  = true;
  programs.gh.enable      = true;
  programs.tmux.enable    = true;
  programs.starship.enable = true;
  programs.zsh.enable     = true;
}
