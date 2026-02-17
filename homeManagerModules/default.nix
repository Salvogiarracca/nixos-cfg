{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cliPrograms/nvf.nix
    ./cliPrograms/wezterm.nix
    ./cliPrograms/vscode.nix
    ./cliPrograms/git.nix
  ];

  nvf.enable = lib.mkDefault true;
  wezterm.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
}
