{ config, pkgs, ... }:

# TODO - Look into nix-colors
# TODO - Look into declarative flatpak (https://github.com/yawnt/declarative-nix-flatpak)
# TODO - Determine good option for terminal (application, font, layout etc.)
# TODO - Look into ShellCheck

{
    programs = {
        home-manager.enable = true;
        bash = {
            enable = true;
        };
        git = {
            enable = true;
            userName = "Jamie Allen";
            userEmail = "jamieallen050401@gmail.com";
        };
        vscode = {
            # TODO - Determine appropriate means to manage vscode and extension configuration
            enable = true;
            package = pkgs.vscodium;
            extensions = with pkgs.vscode-extensions; [
                # UI/Theme:
                # TODO - Add vscode-icons

                # General/QoL
                # TODO - Add Error Lens
                # TODO - Add some kind of code formatting that works across all* languages
                # TODO - Add a good git extension

                # Language Support:
                # TODO - Add C#
                # TODO - Add Ionide for F#
                # TODO - Add Nix
                # TODO - Add Docker
                # TODO - Add markdownlint
            ];
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

        ## General
        firefox
        thunderbird # Email client
        kate # Text editor
        libsForQt5.kdenlive # Video editor
        obs-studio
        mullvad-vpn
        transmission
        vlc

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
    ];

    home.sessionVariables = {
        SHELL="/bin/bash"; # TODO - Verify this works
        EDITOR="nano";
    };

    home.file = {
        # Can be used to capture dotfiles
        # ...
    };

    home.stateVersion = "23.05";
}
