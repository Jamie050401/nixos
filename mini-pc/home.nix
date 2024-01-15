#### User configuration (home manager)
#### Author: Jamie
{ config, pkgs, ... }:

let
    configFilesToLink = {
        #"Path/On/Disk" = ./Relative/Path/In/Repo;
    };
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
        file = {
            # Can be used to capture dotfiles
            # ...
        };
        stateVersion = "23.05";
    };
}
