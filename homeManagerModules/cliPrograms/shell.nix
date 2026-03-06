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
        };
        loginExtra = ''
          if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
              #exec uwsm start default &
              exec uwsm start hyprland-uwsm.desktop
          fi
        '';
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
