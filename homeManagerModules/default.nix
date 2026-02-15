{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cliPrograms/nvf.nix
    ./cliPrograms/wezterm.nix
    ./cliPrograms/vscode.nix
  ];

  nvf.enable = lib.mkDefault true;
  wezterm.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
}
