{
  lib,
  config,
  ...
}:
{
  options = {
    ssh.enable = lib.mkEnableOption "enable ssh";
  };

  config = lib.mkIf config.ssh.enable {
    programs = {
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_ed25519_github";
          };
        };
      };
    };
  };
}
