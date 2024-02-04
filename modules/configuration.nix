{ config, ... }:

let
    pkgs = config.customOptions.pkgs;

    rootSecretPermissions = {
        mode = "0440";
        owner = config.users.users.root.name;
        group = config.users.users.root.group;
    };
    userSecretPermissions = fileName: {
        mode = "0440";
        owner = config.users.users.${config.customOptions.userName}.name;
        group = config.users.users.${config.customOptions.userName}.group;
        path = "${config.customOptions.userFolder}/.secrets/${fileName}";
    };
in {
    imports = [
        ./scripts.nix
    ];

    #### Boot
    boot = {
        kernelPackages = pkgs.v23-11.linuxPackages_latest;
        loader = {
            grub = {
                enable = true;
                configurationLimit = 30;
                device = "nodev";
                efiSupport = true;
                efiInstallAsRemovable = true;
                useOSProber = true;
            };
            timeout = 30;
        };
    };

    #### Secrets
    sops = {
        age.generateKey = false;
        age.keyFile = "${config.customOptions.userFolder}/.age/id";
        defaultSopsFile = ../.secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        validateSopsFiles = false;

        secrets."${config.customOptions.hostName}/ssh-public-key" = userSecretPermissions "ssh-public-key";
        secrets."${config.customOptions.hostName}/ssh-private-key" = userSecretPermissions "ssh-private-key";
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
            defaultSession = "plasmawayland";
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
        git.enable = true;
        zsh.enable = true;
    };
    environment = {
        systemPackages = with pkgs.v23-11; [
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
        defaultUserShell = pkgs.v23-11.zsh;
        users.${config.customOptions.userName} = {
            isNormalUser = true;
            extraGroups = [
                "networkmanager"
                "wheel"
            ];
        };
    };

    #### User Services
    systemd.user.services = {
        systemProvisioning = {
            description = "Performs any/all necessary functions at system start-up";
            path = [ pkgs.v23-11.git ];
            script = ''
                destPath=${config.customOptions.userFolder}/.ssh
                publicKey=${config.sops.secrets."${config.customOptions.hostName}/ssh-public-key".path}
                privateKey=${config.sops.secrets."${config.customOptions.hostName}/ssh-private-key".path}
                mkdir -p $destPath
                ln -f -s $privateKey "$destPath/id_ed25519"
                ln -f -s $publicKey "$destPath/id_ed25519.pub"
                chmod 600 "$destPath/id_ed25519"
                chmod 600 "$destPath/id_ed25519.pub"

                nixRepository="${config.customOptions.userFolder}/Development/Git.Repositories/nixos"
                mkdir -p $nixRepository
                git -C $nixRepository pull || git clone "git@github.com:Jamie050401/nixos.git" $nixRepository
            '';
            wantedBy = ["graphical-session.target"];
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
    xdg.portal.extraPortals = [ pkgs.v23-11.xdg-desktop-portal-kde ];
    nix = {
        package = pkgs.v23-11.nixFlakes;
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
