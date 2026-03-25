{
  pkgs,
  lib,
  config,
  spicetify,
  ...
}:
let
  spicePkgs = spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    spicetify.homeManagerModules.default
  ];

  options = {
    spicetify.enable = lib.mkEnableOption "enable spicetify";
  };

  config = lib.mkIf config.spicetify.enable {
    programs.spicetify = {
      enable = true;

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        beautifulLyrics
      ];
    };
  };
}
