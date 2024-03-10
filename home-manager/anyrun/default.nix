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

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: false,
        max_entries: 5,
        terminal: Some("foot"),
      )
    '';
  };
}
