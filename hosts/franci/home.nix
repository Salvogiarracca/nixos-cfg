{
  pkgs,
  config,
  ...
}:
let
  dotfilesDir = ../../dotfiles; # here I don't care about the symlink, because is in the store anyway (GOOD!)
  linkDotfile = name: {
    source = "${dotfilesDir}/${name}";
  };
in
{
  imports = [
    ../../homeManagerModules/default.nix
  ];

  home.username = "franci";
  home.homeDirectory = "/home/franci";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    XCURSOR_THEME = "Banana";
    EDITOR = "nvim";
  };
  home.file = {
    "nixos-config/walls/lockscreen" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/walls/lockscreen.jpg";
    };
    "nixos-config/walls/wall" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/walls/wallpaper.jpg";
    };
  };
  xdg.configFile = {
    # This require nixos-rebuild switch to apply changes (immutability)
    # waybar = linkDotfile "waybar";
    uwsm = linkDotfile "uwsm";
    # TODO: [DEVELOPMENT] after reaching a good point of the configuration,
    # change the following "not-tracked" dotfiles with the above pattern
    "waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/waybar";
    };
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

  programs.git.settings = {
    user.name = "Francesca Sanna";
    user.email = "francifras97@gmail.com";
  };

  programs.zsh.shellAliases = {
    update = "sudo nixos-rebuild switch --flake .#franci";
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
  home.packages = with pkgs; [
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    adwaita-qt
    hypridle
    hyprpaper
  ];

  blender.enable = false;
}
