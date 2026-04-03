{
  lib,
  config,
  ...
}:
{
  options = {
    shell.enable = lib.mkEnableOption "enable shell";
  };

  config = lib.mkIf config.shell.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
          cd = "z";
          ll = "ls -l";
          la = "ls -al";
          cat = "bat";
          vi = "nvim";
          vim = "nvim";
        };
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      bash = {
        enable = true;
        shellAliases = {
          ll = "ls -l";
          la = "ls -al";
        };
      };
    };
  };
}
