{ pkgs, ... }: {
  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Flakes は Determinate Nix インストーラーが有効化するが念のため明示
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix-darwin が /etc/zshrc を管理するために必要
  programs.zsh.enable = true;

  users.users.kyou = {
    name = "kyou";
    home = "/Users/kyou";
  };
}
