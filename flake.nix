{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      nixpkgs,
      nix-flatpak,
      home-manager,
      nvf,
      spicetify,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      extraSpecialArgs = {
        inherit nvf;
        inherit spicetify;
      };
    in
    {
      nixosConfigurations = {
        salvo = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/salvo/configuration.nix
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.salvo.imports = [ ./hosts/salvo/home.nix ];
              };
            }
          ];
        };

        franci = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/franci/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.franci.imports = [ ./hosts/franci/home.nix ];
              };
            }
          ];
        };
      };
    };
}
