{
  config,
  lib,
  ...
}: let
  cfg = config.wezterm;
in {
  options = {
    wezterm.enable = lib.mkEnableOption "enable wezterm";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/wezterm";
    };

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
