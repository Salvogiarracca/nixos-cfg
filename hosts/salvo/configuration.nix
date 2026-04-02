{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        copyKernels = true;
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "coretemp"
      "jc42"
    ];
  };
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
  # nixpkgs.config.allowUnfree = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    hyprlock.enable = true;
    zsh.enable = true;
    xfconf.enable = true;
  };

  hardware = {
    sensor.iio.enable = true;
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
          AutoEnable = false;
          RemeberPowered = true;
        };
      };
    };
  };

  services = {
    flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        "com.surfshark.Surfshark"
      ];
    };
    getty.autologinUser = "salvo";
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    gvfs.enable = true;
    tumbler.enable = true;
    libinput.enable = true;
    udev.packages = with pkgs; [
      libwacom
      vial
      platformio-core
    ];
    udisks2.enable = true;
  };
  security.polkit.enable = true;

  users = {
    users.salvo = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "bluetooth"
        "video"
        "input"
        "dialout"
      ];
      packages = with pkgs; [
        nix-prefetch-github
        tree
        wofi
        wezterm
        telegram-desktop
        feh
        vlc
        libvlc
        copyq
        localsend
        ungoogled-chromium
      ];
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    waybar
    fastfetch
    wev
    pavucontrol
    brightnessctl
    dua
    bat
    ripgrep
    rsync
    ffmpeg-full
    p7zip
    jq
    poppler
    fd
    resvg
    imagemagick
    iio-sensor-proxy
    rot8
    wvkbd
    libinput
    vial
    direnv
    zip
    unzip
    xdg-utils
    file-roller
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    font-awesome
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11"; # Did you read the comment?
}
