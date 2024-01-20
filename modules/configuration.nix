{ pkgs, config, ... }:

{
    #### Boot
    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
            efi = {
                canTouchEfiVariables = true;
            };
            grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                useOSProber = true;
                configurationLimit = 5;
          };
        timeout = 30;
        };
    };

    #### Hardware
    hardware = {
      pulseaudio.enable = false;
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
        hostName = config.customOptions.hostName;
        #wireless.enable = true;
        networkmanager.enable = true;
        firewall = {
          enable = true;
          #allowedTCPPorts = [ ... ];
          #allowedUDPPorts = [ ... ];
        };
    };

    #### System Packages
    programs = {
        zsh.enable = true;
    };
    environment = {
        systemPackages = with pkgs; [
            # ...
        ];
    };

    #### System Services
    services = {
        openssh.enable = true;
        printing.enable = true;
        flatpak.enable = true;
    };
    
    #### Users
    users = {
        defaultUserShell = pkgs.zsh;
        users.${config.customOptions.userName} = {
            isNormalUser = true;
            extraGroups = [
                "networkmanager"
                "wheel"
            ];
        };
    };

    #### User Services
    systemd.user.services.systemUpdate = {
        description = "Updates/clones my local 'nixos' respository";
        path = [pkgs.git];
        script = ''
            nixRepository = "${config.customOptions.userFolder}/Development/Git.Repositories/nixos"
            mkdir -p $nixRepository
            git -C $nixRepository pull || git clone "https://github.com/Jamie050401/nixos.git" $nixRepository
        '';
        wantedBy = ["graphical-session.target"];
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

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05";
}
