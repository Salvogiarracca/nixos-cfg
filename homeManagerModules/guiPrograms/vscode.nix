{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    vscode.enable = lib.mkEnableOption "enable vscode";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscode-fhs; # Use the FHS version for better extension compatibility

      profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
          vscodevim.vim
          jnoortheen.nix-ide
          mkhl.direnv
          tamasfe.even-better-toml
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
          fill-labs.dependi
          usernamehw.errorlens
          eamodio.gitlens
        ];

        userSettings = {
          "editor.fontSize" = 14;
          "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
          "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
        };
      };
    };
  };
}
