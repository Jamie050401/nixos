{ pkgs, osConfig, ... }:

let
    homeFiles = {
        # Name = Executable, Source, Target
        "autostart" = [true ../../../scripts/autostart ".scripts/autostart"];
        "nix-rebuild" = [true ../../../scripts/nix-rebuild ".scripts/nix-rebuild"];
        "kde-autostart" = [false ../../../dotfiles/autostart/autostart.desktop ".config/autostart/autostart.desktop"];
        "git-ignore" = [false ../../../dotfiles/.gitignore ".gitignore"];
        "yakuake-config" = [false ../../../dotfiles/yakuakerc ".config/yakuakerc"];
    };

    convertHomeFile = name: values: {
        enable = true;
        executable = pkgs.lib.elemAt values 0;
        source = pkgs.lib.elemAt values 1;
        target = pkgs.lib.elemAt values 2;
    };
in {
    programs = {
        git = {
            enable = true;
            extraConfig = {
                core = { excludesfile = "${osConfig.customOptions.userFolder}/.gitignore"; };
                init = { defaultBranch = "main"; };
                pull = { rebase = "false"; };
            };
            userEmail = "${osConfig.customOptions.userEmail}";
            userName = "${osConfig.customOptions.fullName}";
        };
        tmux = {
            clock24 = true;
            enable = true;
            mouse = false;
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

        stateVersion = "23.05";
    };
}
