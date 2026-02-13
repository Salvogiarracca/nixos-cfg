{
    description = "NixOS config";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nvf = {
            url = "github:notashelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, nvf, ... }@inputs: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            system = "x86_64-linux";
            modules = [
                ./hosts/laptop/configuration.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        backupFileExtension = "backup";
                        users.salvo = {
                             imports = [
                                ./hosts/laptop/home.nix
                            ];
                        };
                        extraSpecialArgs = { inherit nvf; };
                    };
                }
            ];
        };
    };
}
