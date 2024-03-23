{config, pkgs, ... }: 
{
  imports = [
    ./bindings.nix
    ./rules.nix
    ./settings.nix
  ];

  home.packages = with pkgs; with gnome; [
    wlr-randr
    jaq
    adw-gtk3
    morewaita-icon-theme
    gnome.adwaita-icon-theme
    adwaita-icon-theme
    gnome-text-editor
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
  ];

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };
}
