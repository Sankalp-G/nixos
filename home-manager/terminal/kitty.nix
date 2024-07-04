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
      window_padding_width 6
      hide_window_decorations yes
      draw_minimal_borders yes
      enable_audio_bell no
      kitty_mod alt
      background_opacity 0.9

      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+c copy_to_clipboard
      map kitty_mod+enter launch --cwd=current
      map kitty_mod+t launch --cwd=current --type=tab
      map kitty_mod+z toggle_layout stack
    '';
  };
}
