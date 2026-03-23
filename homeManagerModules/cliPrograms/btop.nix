{
  lib,
  config,
  ...
}:
{
  options = {
    btop.enable = lib.mkEnableOption "enable btop";
  };

  config = lib.mkIf config.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        truecolor = true;
        update_ms = 500;
      };
    };
  };
}
