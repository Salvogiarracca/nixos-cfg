{ config, pkgs, ... }:

{
    home.username = "salvo";
    home.homeDirectory = "/home/salvo";
    home.stateVersion = "25.11";
    xdg.configFile = {
        "hypr" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos-config/dotfiles/hypr";
        };
        "waybar" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos-config/dotfiles/waybar";
        };
        "wezterm" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos-config/dotfiles/wezterm";
        };
    };
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
    programs.bash = {
        enable = true;
        shellAliases = {
            ll = "ls -l";
            la = "ls -al";
            btw = "echo i use nix finally!";
        };
        profileExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                exec uwsm start default &
                #exec uwsm start -S hyprland-uwsm.desktop &
            fi
        '';
    };
    # uwsm conflict fix
    wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
    };
}
