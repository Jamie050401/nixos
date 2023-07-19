#### Main configuration file for NixOS (for deployment on VMs with a desktop environment)
#### Author: Jamie

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  #### Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    #initrd.kernelModules = [
    #  "amdgpu"
    #];
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        configurationLimit = 5;
      };
    timeout = 5;
    };
  };

  #### Hardware
  hardware = {
    pulseaudio.enable = false;
    opengl = {
      driSupport32Bit = true;
      #extraPackages = [
      #  rocm-opencl-icd
      #  pkgs.amdvlk
      #];
      #opengl.extraPackages32 = [
      #  pkgs.driversi686Linux.amdvlk
      #];
    };
  };

  #### Windowing System
  services.xserver = {
    enable = true;
    ## Display Manager
    displayManager = {
      sddm.enable = true;
    };
    ## Desktop Environment
    desktopManager = {
      plasma5.enable = true;
    };
    ## Keymap
    layout = "gb";
    xkbVariant = "";
    ## Touchpad
    libinput.enable = true;
  };

  #### Audio
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #### Networking
  networking = {
    hostName = "nixos-desktop";
    #wireless.enable = true;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      #allowedTCPPorts = [ ... ];
      #allowedUDPPorts = [ ... ];
    };
  };

  #### System Packages
  environment.systemPackages = with pkgs; [
    # ...
  ];

  #### System Services
  services = {
    #openssh.enable = true;
    printing.enable = true;
    flatpak.enable = true;
  };

  #### Users
  users.users.jamie = {
    isNormalUser = true;
    description = "Jamie Allen";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager = {
    useGlobalPkgs = true;
    users.jamie = { pkgs, ... }: {
      home.packages = with pkgs; [
        ## TODO
        # 1. VorpX
        # 2. VKB Configurator
        # 3. Stable Diffusion (maybe running in a docker container?)
        # 4. NT Lite

        ## Flatpak
        # 1. Flatseal
        # 2. Discord
        # 3. MEGASync

        ## Pre-reqs
        python311Full
        temurin-jre-bin-18
        dotnet-sdk_7
        wget
        git
        rclone
        
        ## General
        firefox
        thunderbird # Email client
        kate # Text editor
        libsForQt5.kdenlive # Video editor
        obs-studio
        mullvad-vpn
        transmission
        vlc
        spotify
        
        ## Utilities
        keepassxc
        otpclient # WinAuth alternative
        wireguard-go
        protonmail-bridge
        pcloud
        go-sct # f.lux alternative
        flameshot # ShareX alternative
        hwinfo
        docker
        docker-compose
        distrobox

        ## Gaming
        wine64
        winetricks
        protonup-qt
        protontricks
        lutris
        steam
        ryujinx
        yuzu-mainline
        citra-nightly
        prismlauncher-qt5

        ## Development
        kdiff3
        vscodium # Add GitLens to vs code instead of Git Extensions
      ];
      home.file = {
        # Can be used to capture dotfiles
        # ...
      };
      home.stateVersion = "23.05";
      programs.bash.enable = true;
    };
  };

  #### Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  console.keyMap = "uk";

  #### Misc
  nixpkgs.config.allowUnfree = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      channel = "https://nixos.org/channels/nixos-23.05";
      dates = "weekly";
    };
  };
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delte-older-than 10d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";
}
