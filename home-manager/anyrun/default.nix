{inputs, pkgs, ...}:

{
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        translate
        randr
      ];
      width.fraction = 0.3;
      y.fraction = 0.4;
      hideIcons = false;
      ignoreExclusiveZones = false;
      hidePluginInfo = true;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
    };

    extraCss = builtins.readFile (./style.css);
  };
}
