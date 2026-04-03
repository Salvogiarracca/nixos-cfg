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
      package = pkgs.unstable.vscode-fhs;

      profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
          asvetliakov.vscode-neovim
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
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };
          "github.copilot.enable" = {
            "*" = false;
          };
          "github.copilot.editor.enableAutoCompletions" = false;
          "inlineSuggest.enabled" = false;
        };
      };
    };
    home.activation.vscodeArgv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      argv="$HOME/.vscode/argv.json"
      if [ -f "$argv" ]; then
        tmp=$(grep -v '^\s*//' "$argv" | ${pkgs.jq}/bin/jq '. + {"password-store": "gnome-libsecret"}')
        echo "$tmp" > "$argv"
      fi
    '';
  };
}
