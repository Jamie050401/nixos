{ pkgs, osConfig, ... }:

{
    programs = {
        git.enable = true;
        zsh = {
            enable = true;
            shellAliases = {
                ll = "ls -l";
            };
            oh-my-zsh = {
                enable = true;
                plugins = [];
                theme = "amuse";
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
            tmux

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

        file = {
            autostartScript = {
                enable = true;
                executable = true;
                source = ../scripts/autostart;
                target = ".scripts/autostart";
            };
            autostartKDE = {
                enable = true;
                source = ../dotfiles/autostart/autostart.desktop;
                target = ".config/autostart/autostart.desktop";
            };
            gitConfig = {
                enable = true;
                source = ../dotfiles/.gitconfig;
                target = ".gitconfig";
            };
            gitIgnore = {
                enable = true;
                source = ../dotfiles/.gitignore;
                target = ".gitignore";
            };
            yakuakeConfig = {
                enable = true;
                source = ../dotfiles/yakuakerc;
                target = ".config/yakuakerc";
            };
        };

        stateVersion = "23.05";
    };
}
