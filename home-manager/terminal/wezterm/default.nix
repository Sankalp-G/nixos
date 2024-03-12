{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require "wezterm"

      return {
        check_for_updates = false,
        color_scheme = 'Everblush',
        default_cursor_style = 'SteadyBar',
        enable_scroll_bar = true,
        font_size = 14,
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        window_background_opacity = 0.9,
        font = wezterm.font('JetBrains Mono', { weight = 'Medium' }),
        window_padding = {
          left = 0,
          right = -2,
          top = 0,
          bottom = 0,
        },
      }
    '';
  };
}
