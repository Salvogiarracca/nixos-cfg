{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.blender;
  mkAddon =
    {
      name,
      owner,
      repo,
      rev,
      sha256,
    }:
    pkgs.stdenv.mkDerivation {
      pname = name;
      version = rev;
      src = pkgs.fetchFromGitHub {
        inherit
          owner
          repo
          rev
          sha256
          ;
      };
      installPhase = "mkdir -p $out; cp -r . $out/";
    };

  myAddons = {
    "BlenderGIS" = mkAddon {
      name = "blender-gis";
      owner = "domlysz";
      repo = "BlenderGIS";
      rev = "v2.2.15";
      sha256 = "sha256-Bc/ldJvpkijkiX4Eivq5MX5Ykn7p8H5AOp5ZxKmXIxg=";
    };
  };

  blenderVer = "5.0";
in
{
  options.blender.enable = lib.mkEnableOption "enable blender";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.blender ];

    xdg.configFile = (
      #TODO: try to enable automatically addons
      #but at the moment it does not work
      {
        "blender/${blenderVer}/scripts/startup/enable_addons.py".text = ''
          import bpy
          import addon_utils

          addons_to_enable = [
            ${lib.concatMapStringsSep ", " (name: "'${name}'") (builtins.attrNames myAddons)}
          ]

          for addon in addons_to_enable:
              if addon not in bpy.context.preferences.addons:
                  print(f"NixOS: Enabling addon {addon}")
                  try:
                      addon_utils.enable(addon, default_set=True)
                  except Exception as e:
                      print(f"NixOS Error: Could not enable {addon}: {e}")
        '';
      }
      // (lib.mapAttrs' (name: value: {
        name = "blender/${blenderVer}/scripts/addons/${name}";
        value = {
          source = value;
        };
      }) myAddons)
    );
  };
}
