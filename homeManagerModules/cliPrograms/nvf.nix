{
  pkgs,
  lib,
  config,
  nvf,
  ...
}: {
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
        vim = {
          viAlias = true;
          vimAlias = true;
          globals.mapleader = " ";
          binds.whichKey.enable = true;
          statusline.lualine.enable = true;
          autocomplete.nvim-cmp.enable = true;
          telescope.enable = true;
          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = true;
            lspsaga.enable = true;
          };
          languages = {
            enableTreesitter = true;
            enableFormat = true;
            nix = {
              enable = true;
              # format.enable = true;
              # format.type = "nixfmt";
            };
            rust.enable = true;
          };
          visuals = {
            nvim-web-devicons.enable = true;
          };
          ui = {
            noice.enable = true;
            borders.enable = true;
          };
          options = {
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
            softtabstop = 4;
          };
          tabline.nvimBufferline.enable = true;
        };
      };
    };
  };
}
