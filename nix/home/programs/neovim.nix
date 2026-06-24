{ lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraWrapperArgs = [
      "--set" "TELESCOPE_FZF_NATIVE"
      "${pkgs.vimPlugins.telescope-fzf-native-nvim}"
      "--set" "TREESITTER_GRAMMARS"
      "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}"
      "--set" "JAVA_DEBUG_DIR"
      "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server"
      "--set" "LOMBOK_JAR"
      "${pkgs.lombok}/share/java/lombok.jar"
    ];
    extraPackages = with pkgs; [
      typescript-language-server
      rust-analyzer
      prettier
      stylua
      nixd
      nixfmt-rfc-style
      statix
      jdt-language-server
      google-java-format
      vscode-extensions.vscjava.vscode-java-debug
      lombok
    ];
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
}
