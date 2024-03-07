{
  lib,
  self,
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    ./terminal
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

  home = {
    username = "sankalp";
    homeDirectory = "/home/sankalp";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  systemd.user.startServices = "sd-switch";
}
