{
  config,
  lib,
  ...
}: {
  options = {
    wezterm.enable = lib.mkEnableOption "enable wezterm";
  };

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;
      settings = {
        enable_tab_bar = false;
        enable_scroll_bar = false;
        scrollback_lines = 10000;
      };
    };
  };
}
