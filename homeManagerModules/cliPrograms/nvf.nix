{ config, lib, pkgs, ... }:

let
    cfg = config.myHome.cliPrograms.nvf;
in {
    options.myHome.cliPrograms.nvf.enable = lib.mkEnableOption "nvf module";
        
    config = lib.mkIf cfg.enable {
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
