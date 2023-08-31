#### Global configuration file for NixOS
#### Author: Jamie

{ config, pkgs, ... }:

{
  #### Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
        configurationLimit = 5;
      };
    timeout = 5;
    };
  };

  #### Hardware
  hardware = {
    opengl = {
      driSupport32Bit = true;
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
    layout = "gb";
    xkbVariant = "";
    libinput.enable = true;
  };

  #### Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #### Networking
  networking = {
    wireless.enable = true;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      #allowedTCPPorts = [ ... ];
      #allowedUDPPorts = [ ... ];
    };
  };

  #### System Packages
  environment.systemPackages = with pkgs; [
    python311Full
    temurin-jre-bin-18
    dotnet-sdk_7
    wget
    rclone
    kdiff3
  ];

  #### System Services
  services = {
    openssh.enable = true; # TODO - Need to sort out SSH configuration/keygen
    printing.enable = true;
    flatpak.enable = true;
  };

  #### Users
  users.users.jamie = {
    isNormalUser = true;
    description = "Jamie Allen";
    extraGroups = [
      # TODO - Consider other groups that should be added
      "networkmanager"
      "wheel"
    ];
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
      options = "--delete-older-than 10d";
    };
  };

  system.stateVersion = "23.05";
}
