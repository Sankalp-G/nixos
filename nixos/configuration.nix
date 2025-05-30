{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./stylix.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;

      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [
    { device = "/dev/nvme0n1p8"; }
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8001 8081 ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.power-profiles-daemon.enable = true;
  services.tlp = {
    enable = false;
    settings = {
      START_CHARGE_THRESH_BAT0=75;
      STOP_CHARGE_THRESH_BAT0=80;
    };
   };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.localBinInPath = true;

  programs.zsh.enable = true;
  programs.adb.enable = true;
  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "sankalp" ];

  boot.supportedFilesystems = [ "ntfs" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sankalp = {
    isNormalUser = true;
    description = "Sankalp";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers" ];
    packages = with pkgs; [
      floorp
      google-chrome
      slack
      vesktop
      telegram-desktop
      spotify
      htop
      tealdeer
      jq
      libqalculate
      dbeaver-bin
      zathura
      distrobox
      bat
      emacs
      kitty
      pkgs-unstable.neovim
      neovide
      android-studio
      obsidian
      onlyoffice-bin_latest
      drawio
      pkgs-unstable.zed-editor
      serverless
      exiftool
      file
      mpv
      bambu-studio
      fastfetch
      pkgs-unstable.blender
      obs-studio
      pkgs-unstable.code-cursor
      pkgs-unstable.warp-terminal
      (callPackage ../pkgs/zen.nix {})
    ];
  };

  environment.systemPackages = with pkgs; [
    android-tools
    git
    ripgrep
    yazi
    eza
    python310
    python310Packages.pip
    python310Packages.virtualenv
    nodejs_22
    corepack
    ruby
    go
    llvmPackages.libcxxClang
    clang-tools
    postgresql
    wget
    libgcc
    unzip
    p7zip
    gnumake
    zlib
    gcc.cc
    glibc
    fzf
    stripe-cli
    openjdk21
    maven

    # gnome extensions
    (pkgs.callPackage ../pkgs/gnomeExtensions/pano.nix { })
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.forge
    gnomeExtensions.burn-my-windows
    gnomeExtensions.just-perfection
    gnomeExtensions.blur-my-shell
    gnomeExtensions.color-picker
    gnomeExtensions.astra-monitor
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
    inter
  ];

  networking.hostName = "odyssey";
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "24.05";
}
