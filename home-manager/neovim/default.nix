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

    extraPackages = with pkgs; [gcc ripgrep fd];

    # extraConfig = lib.fileContents ./config/init.lua;
  };
}
