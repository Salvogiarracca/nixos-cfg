{
  lib,
  config,
  ...
}: {
  options = {
    yazi.enable = lib.mkEnableOption "enable yazi";
  };

  config = lib.mkIf config.yazi.enable {
    programs = {
      yazi = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          mgr = {
            show_hidden = true;
            ratio = [2 2 4];
          };
        };
      };
    };
  };
}
