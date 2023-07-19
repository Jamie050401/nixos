{ config, pkgs, ... }:

{
    programs = {
        bash.enable = true;
        git = {
            enable = true;
            userName = "Jamie Allen";
            userEmail = "jamieallen050401@gmail.com";
        };
    };
    home.username = "jamie";
    home.homeDirectory = "/home/jamie";
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
    vscodium
    ];
    home.file = {
    # Can be used to capture dotfiles
    # ...
    };
    home.stateVersion = "23.05";
}