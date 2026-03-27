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

  home.username = "salvo";
  home.homeDirectory = "/home/salvo";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    XCURSOR_THEME = "Banana";
    # XCURSOR_SIZE = "24";
    # QT_QPA_PLATFORMTHEME = "qt5ct"; conflict with gtk,but nice to know
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

  systemd.user.services.battery-notifier = {
    Unit = {
      Description = "Battery level notifier service";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "battery-check" ''
        while true; do
          if [ -d /sys/class/power_supply/BAT1 ]; then
            LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
            STATUS=$(cat /sys/class/power_supply/BAT1/status)

            if [ "$STATUS" = "Discharging" ]; then
              if [ "$LEVEL" -le 5 ]; then
                ${pkgs.libnotify}/bin/notify-send -u critical "Battery Critical" "Plug in immediately! Level: $LEVEL%"
              elif [ "$LEVEL" -le 15 ]; then
                ${pkgs.libnotify}/bin/notify-send -u normal "Battery Low" "Level: $LEVEL%"
              fi
            fi
          fi
          sleep 60
        done
      ''}";
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      # This starts the service automatically when your session starts
      WantedBy = [ "graphical-session.target" ];
    };
  };
  # systemd.user.services.battery-notifier = {
  #   Unit = {
  #     Description = "Battery level notifier";
  #     # PartOf ensures it stops when the session ends
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.writeShellScript "battery-check" ''
  #       while true; do
  #         LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
  #         STATUS=$(cat /sys/class/power_supply/BAT1/status)
  #         if [ "$STATUS" = "Discharging" ] && [ "$LEVEL" -le 5 ]; then
  #           ${pkgs.libnotify}/bin/notify-send -u critical -t 0 "Battery Critical" "Level: $LEVEL%"
  #         fi
  #         sleep 60
  #       done
  #     ''}";
  #   };
  #   Install = {
  #     # This is the 'trigger'—it starts when your Wayland session is ready
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  # };

  programs.git.settings = {
    user.name = "Salvatore Giarracca";
    user.email = "salvogiarracca07@gmail.com";
  };

  programs.zsh.shellAliases = {
    update = "sudo nixos-rebuild switch --flake .#salvo";
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
    orca-slicer
    bluetui
    bluez
    libnotify
  ];
  services = {
    mako = {
      enable = true;
      settings = {
        font = "JetBrainsMono Nerd Font 10";
        background-color = "#1e1e2e";
        text-color = "#cdd6f4";
        border-color = "#89b4fa";
        border-radius = 8;
        border-size = 2;
        padding = "15";
        default-timeout = 5000;
        anchor = "top-right";
      };
      extraConfig = ''
        [urgency=critical]
        background-color=#f38ba8
        text-color=#11111b
        border-color=#eba0ac
        default-timeout=0
      '';
    };
  };
  # blender.enable = false;
}
