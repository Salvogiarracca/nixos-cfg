{
  lib,
  config,
  lazyvim,
  pkgs,
  ...
}:
{
  imports = [
    lazyvim.homeManagerModules.default
  ];

  options = {
    lazyvim.enable = lib.mkEnableOption "enable lazyvim";
  };

  config = lib.mkIf config.lazyvim.enable {
    programs.lazyvim = {
      enable = true;
      installCoreDependencies = true;
      pluginSource = "latest";
      extras = {
        plugins.vscode.enable = true;
        lang = {
          nix = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
          python = {
            enable = true;
            installDependencies = true; # Install ruff
            installRuntimeDependencies = true; # Install python3
          };
          rust = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };
        # lang.go = {
        #   enable = true;
        #   installDependencies = true;        # Install gopls, gofumpt, etc.
        #   installRuntimeDependencies = true; # Install go compiler
        # };
      };

      # Additional packages (optional)
      extraPackages = with pkgs; [
        nixd
        alejandra
        rustfmt
        statix
        nixfmt
        shfmt
        stylua
        fish
        ast-grep
        luarocks
        lua
        tree-sitter
        trash-cli
        ghostscript
        mermaid-cli
        tectonic
        lua-language-server
        pyright
      ];
      # plugins.snacks = ''
      #   return {
      #     "folke/snacks.nvim",
      #     opts = {
      #       image = { enabled = true },
      #     },
      #   }
      # '';
      # Only needed for languages not covered by LazyVim extras
      treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        css
        scss
        svelte
        vue
        latex
        #norg
        typst
      ];
    };
  };
}
