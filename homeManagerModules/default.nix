{lib, ...}: {
  imports = [
    #CLI
    ./cliPrograms/nvf.nix
    ./cliPrograms/git.nix
    ./cliPrograms/shell.nix
    #GUI
    ./guiPrograms/wezterm.nix
    ./guiPrograms/vscode.nix
  ];

  #CLI
  nvf.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  shell.enable = lib.mkDefault true;

  #GUI
  wezterm.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
}
