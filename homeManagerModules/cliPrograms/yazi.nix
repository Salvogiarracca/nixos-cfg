{
  pkgs,
  lib,
  config,
  ...
}:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "25918dcde97f11ac37f80620cc264680aedc4df8";
    hash = "sha256-TzHJNIFZjUOImZ4dRC0hnB4xsDZCOuEjfXRi2ZXr8QE=";
  };
in
{
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
            ratio = [
              2
              2
              4
            ];
          };
        };
        plugins = {
          chmod = "${yazi-plugins}/chmod.yazi";
          full-border = "${yazi-plugins}/full-border.yazi";
          toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
          fr = pkgs.fetchFromGitHub {
            owner = "lpnh";
            repo = "fr.yazi";
            rev = "aa88cd4d4345c07345275291c1a236343f834c86";
            sha256 = "sha256-3D1mIQpEDik0ppPQo+/NIhCxEu/XEnJMJ0HiAFxlOE4=";
          };
        };
      };
    };
  };
}
