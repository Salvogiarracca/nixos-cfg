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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nvf,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      extraSpecialArgs = { inherit nvf; };
    in
    {
      nixosConfigurations = {
        salvo = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/salvo/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
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
                users.franci.imports = [ ./hosts/franci/home.nix ];
              };
            }
          ];
        };
      };
    };
}
