{ pkgs, lib, ... }: {
    
    imports = [
        ./cliPrograms/nvf.nix
    ];

    nvf.enable = lib.mkDefault true;
}

