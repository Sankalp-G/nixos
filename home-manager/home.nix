{
  lib,
  self,
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    ./neovim
    ./terminal
    ./anyrun
    ./hyprland
    ./ags
    ./gtk
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  programs.neovim.enable = true;
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.zoxide.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
  
  home = {
    username = "sankalp";
    homeDirectory = "/home/sankalp";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  systemd.user.startServices = "sd-switch";
}
