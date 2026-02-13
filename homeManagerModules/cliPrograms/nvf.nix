{ pkgs, lib, config, nvf, ... }: {

    imports = [
        nvf.homeManagerModules.default
    ];

    options = {
        nvf.enable = lib.mkEnableOption "enable nvf";
    };

    config = lib.mkIf config.nvf.enable {
        programs.nvf = {
            enable = true;
            settings = {
                vim.viAlias = true;
                vim.vimAlias = true;
                vim.lsp.enable = true;
                vim.telescope.enable = true;
            };
        };
    };
}
