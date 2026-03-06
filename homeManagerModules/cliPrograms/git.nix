{
  lib,
  config,
  ...
}:
{
  options = {
    git.enable = lib.mkEnableOption "enable git";
  };

  config = lib.mkIf config.git.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          # user = {
          #   name = "Salvatore Giarracca";
          #   email = "salvogiarracca07@gmail.com";
          # };
          init.defaultBranch = "main";
        };
      };
      lazygit.enable = true;
    };
  };
}
