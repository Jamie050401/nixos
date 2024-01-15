#### User configuration (home manager)
#### Author: Jamie
{ config, pkgs, ... }:

let
    configFilesToLink = {
        #"Path/On/Disk/In/~/.config" = ./Relative/Path/In/Repo;
    };

    homeFilesToLink = {
        #"Path/On/Disk/In/~" = ./Relatvie/Path/In/Repo;
    };

    # Helper function
    toSource = configDirName: dotfilesPath: { source = dotfilesPath; };
in
{
    programs = {
        git = {
            enable = true;
            userName = "Jamie Allen";
            userEmail = "jamieallen050401@gmail.com";
        };
    };
    home = {
        username = "jamie";
        homeDirectory = "/home/jamie";
        packages = with pkgs; [
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
        file = pkgs.lib.attrsets.mapAttrs toSource homeFilesToLink; # Symlinks homeFilesToLink to the ~/ directory
        stateVersion = "23.05";
    };
    xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink; # Symlinks configFilesToLink to the ~/.config directory
}
