{
  lib,
  config,
  nvf,
  ...
}:
{
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
          statusline.lualine = {
            enable = true;
            theme = "tokyonight";
          };
          autocomplete.nvim-cmp.enable = true;
          telescope.enable = true;
          theme = {
            enable = true;
            name = "tokyonight";
            style = "storm";
            transparent = false;
          };
          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = true;
            lspsaga.enable = true;
          };
          formatter.conform-nvim = {
            enable = true;
          };
          treesitter = {
            enable = true;
            fold = false;
            highlight.enable = true;
            context.enable = true;
          };
          mini = {
            align.enable = true;
            completion.enable = true;
            # keymap.enable = true;
            basics.enable = true;
            git.enable = true;
          };
          autopairs.nvim-autopairs.enable = true;
          languages = {
            enableTreesitter = true;
            # enableFormat = true;
            nix = {
              enable = true;
              extraDiagnostics.enable = true;
              format.enable = true;
              format.type = [ "nixfmt" ];
              lsp = {
                enable = true;
                servers = [ "nixd" ];
              };
              treesitter.enable = true;
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
            # clipboard.enable = true;
            # autoindent = true;
            # breakindent = true;
            # smartindent = false;
            # tabstop = 2;
            # shiftwidth = 2;
            # expandtab = true;
            # softtabstop = 2;
          };
          # tabline.nvimBufferline.enable = true;
        };
      };
    };
  };
}
