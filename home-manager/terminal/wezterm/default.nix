{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local padding = {
        left = '1cell',
        right = '1cell',
        top = '0.5cell',
        bottom = '0.5cell',
      }

      wezterm.on('update-status', function(window, pane)
        local overrides = window:get_config_overrides() or {}
        if string.find(pane:get_title(), 'NVIM') then
          overrides.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
          }
        else
          overrides.window_padding = padding
        end
        window:set_config_overrides(overrides)
      end)

      return {
        check_for_updates = false,
        color_scheme = 'Everblush',
        default_cursor_style = 'SteadyBar',
        enable_scroll_bar = true,
        font_size = 11,
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        window_background_opacity = 0.9,
        font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
      }
    '';
  };
}
