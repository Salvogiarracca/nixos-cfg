{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cliPrograms/nvf.nix
    ./cliPrograms/wezterm.nix
  ];

  nvf.enable = lib.mkDefault true;
  wezterm.enable = lib.mkDefault true;
}
