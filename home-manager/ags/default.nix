{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.astal.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
    fd
    brightnessctl
    swww
    inputs.matugen.packages.${system}.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
    util-linux
    gnome.gnome-control-center
    mission-center
  ];

  programs.astal = {
    enable = true;
    extraPackages = with pkgs; [
      libadwaita
    ];
  };

  programs.ags = {
    enable = true;
    configDir = ./config;
    # extraPackages = with pkgs; [
    #   accountsservice
    # ];
  };

  systemd.user.services.ags = {
    Unit = {
      Description = "Aylur's Gtk Shell";
      PartOf = [
        "tray.target"
        "graphical-session.target"
      ];
    };
    Service = {
      # Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      ExecStart = "${config.programs.ags.package}/bin/ags";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
