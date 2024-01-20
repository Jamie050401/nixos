{ pkgs, osConfig, ... }:

let
    homeFiles = {
        # Name = Enable, Executable, Source, Target
        "autostart" = [true true ../../../scripts/autostart ".scripts/autostart"];
        "nix-rebuild" = [true true ../../../scripts/nix-rebuild ".scripts/nix-rebuild"];
        "kde-autostart" = [true false ../../../dotfiles/autostart/autostart.desktop ".config/autostart/autostart.desktop"];
        "git-config" = [true false ../../../dotfiles/.gitconfig ".gitconfig"];
        "git-ignore" = [true false ../../../dotfiles/.gitignore ".gitignore"];
        "yakuake-config" = [true false ../../../dotfiles/yakuakerc ".config/yakuakerc"];
    };

    convertHomeFile = name: values: {
        enable = pkgs.lib.elemAt values 0;
        executable = pkgs.lib.elemAt values 1;
        source = pkgs.lib.elemAt values 2;
        target = pkgs.lib.elemAt values 3;
    };
in {
    programs = {
        git.enable = true;
        tmux = {
            clock24 = true;
            enable = true;
            mouse = true;
            newSession = true;
        };
        zsh = {
            enable = true;
            oh-my-zsh = {
                enable = true;
                plugins = [];
                theme = "amuse";
            };
            shellAliases = {
                ll = "ls -l";
                nix-rebuild = "${osConfig.customOptions.userFolder}/.scripts/nix-rebuild";
            };
        };
    };

    home = {
        username = osConfig.customOptions.userName;
        homeDirectory = osConfig.customOptions.userFolder;
        packages = with pkgs; [
            age
            firefox
            libsForQt5.yakuake

            # 1. VorpX
            # 2. VKB Configurator
            # 3. Stable Diffusion (maybe running in a docker container?)
            # 4. NT Lite

            ## Flatpak
            # 1. Flatseal
            # 2. Discord
            # 3. MEGASync

            #python311Full
            #temurin-jre-bin-18
            #dotnet-sdk_7
            #wget
            #rclone
            #firefox
            #thunderbird # Email client
            #kate # Text editor
            #libsForQt5.kdenlive # Video editor
            #obs-studio
            #mullvad-vpn
            #transmission
            #vlc
            #spotify
            #keepassxc
            #otpclient # WinAuth alternative
            #wireguard-go
            #protonmail-bridge
            #pcloud
            #go-sct # f.lux alternative
            #flameshot # ShareX alternative
            #hwinfo
            #docker
            #docker-compose
            #distrobox
            #wine64
            #winetricks
            #protonup-qt
            #protontricks
            #lutris
            #steam
            #ryujinx
            #yuzu-mainline
            #citra-nightly
            #prismlauncher-qt5
            #kdiff3
            #vscodium
        ];

        file = pkgs.lib.mapAttrs convertHomeFile homeFiles;

#        file = {
#            autostartScript = {
#                enable = true;
#                executable = true;
#                source = ../../../scripts/autostart;
#                target = ".scripts/autostart";
#            };
#            nixRebuildScript = {
#                enable = true;
#                executable = true;
#                source = ../../../scripts/nix-rebuild;
#                target = ".scripts/nix-rebuild";
#            };
#            autostartKDE = {
#                enable = true;
#                source = ../../../dotfiles/autostart/autostart.desktop;
#                target = ".config/autostart/autostart.desktop";
#            };
#            gitConfig = {
#                enable = true;
#                source = ../../../dotfiles/.gitconfig;
#                target = ".gitconfig";
#            };
#            gitIgnore = {
#                enable = true;
#                source = ../../../dotfiles/.gitignore;
#                target = ".gitignore";
#            };
#            yakuakeConfig = {
#                enable = true;
#                source = ../../../dotfiles/yakuakerc;
#                target = ".config/yakuakerc";
#            };
#        };

        stateVersion = "23.05";
    };
}
