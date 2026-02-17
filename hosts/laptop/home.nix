{
  config,
  pkgs,
  ...
}: let
  dotfilesDir = ../../dotfiles; #here I don't care about the symlink, because is in the store anyway (GOOD!)
  linkDotfile = name: {
    source = "${dotfilesDir}/${name}";
  };
in {
  imports = [
    ../../homeManagerModules/default.nix
  ];

  home.username = "salvo";
  home.homeDirectory = "/home/salvo";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
  };
  xdg.configFile = {
    # This require nixos-rebuild switch to apply changes (immutability)
    waybar = linkDotfile "waybar";
    uwsm = linkDotfile "uwsm";
    # TODO: [DEVELOPMENT] after reaching a good point of the configuration,
    # change the following "not-tracked" dotfiles with the above pattern
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/hypr";
    };
    # NOTE: the following syntax, even if works, it is not a real symlink to ~/nixos-config/dotfiles/wofi
    # what nix does is looking at the directory (relative tho this file) and create a copy into the nix store.
    # this breaks the expected behavior (instantly source of the dotfile).
    # "wofi" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wofi";
    # };
    # Doing in the following way (absolute-path), the symlink is real to "nixos-config/dotfiles/wofi" (triple indirection: expected).
    "wofi" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/wofi";
    };
  };
  programs.lazygit.enable = true;
  gtk = {
    enable = true;

    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  programs.hyprlock.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Salvatore Giarracca";
        email = "salvogiarracca07@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cd = "z";
      ll = "ls -l";
      la = "ls -al";
      update = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos-config#nixos";
    };
    loginExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          #exec uwsm start default &
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -al";
    };
  };
  # uwsm conflict fix
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
