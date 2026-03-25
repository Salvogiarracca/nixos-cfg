{ lib, ... }:
{
  imports = [
    #CLI
    ./cliPrograms/nvf.nix
    ./cliPrograms/git.nix
    ./cliPrograms/shell.nix
    ./cliPrograms/yazi.nix
    ./cliPrograms/btop.nix
    #GUI
    ./guiPrograms/wezterm.nix
    ./guiPrograms/vscode.nix
    ./guiPrograms/theme.nix
    ./guiPrograms/blender.nix
    ./guiPrograms/spicetify.nix
  ];

  #CLI
  nvf.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  shell.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  btop.enable = lib.mkDefault true;

  #GUI
  wezterm.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
  theme.enable = lib.mkDefault true;
  blender.enable = lib.mkDefault true;
  spicetify.enable = lib.mkDefault true;
}
