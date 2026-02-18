{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    theme.enable = lib.mkEnableOption "enable gtk + qt theme";
  };

  config = lib.mkIf config.theme.enable {
    gtk = {
      enable = true;

      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };
  };
}
