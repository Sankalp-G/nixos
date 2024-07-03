{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    font.name = "JetBrainsMono Nerd Font";
    theme = "Everforest Dark Hard";

    extraConfig = ''
      window_margin_width 8
      hide_window_decorations yes
    '';
  };
}
