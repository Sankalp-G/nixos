# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./terminal/zsh.nix
    ./terminal/kitty.nix
    ./neovim
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "sankalp";
    homeDirectory = "/home/sankalp";
  };

  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
  };
  programs.mise.enable = true;
  programs.fzf.enable = true;
  programs.nix-index-database.comma.enable = true; 

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
