{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    vscode.enable = lib.mkEnableOption "enable vscode";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode-fhs; # Use the FHS version for better extension compatibility

      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];

      userSettings = {
        "editor.fontSize" = 14;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
      };
    };
  };
}
