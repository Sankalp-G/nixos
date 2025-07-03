{pkgs, xdg, lib, ...}: {
  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    defaultEditor = true;

    extraPackages = with pkgs; [gcc glibc ripgrep fd go nodejs_22 python3 unzip wl-clipboard fzf cargo rustup];
  };
}
