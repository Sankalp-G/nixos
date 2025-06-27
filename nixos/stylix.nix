{ config, pkgs, ... }: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../wallpapers/evening-sky.png;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
}
