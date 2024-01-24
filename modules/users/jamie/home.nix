{ osConfig, ... }:

let
    pkgs = osConfig.customOptions.pkgs;

    # stable-diffusion in docker?

    packages = {
        v23-11 = with pkgs.v23-11; [
            age
            firefox
            keepassxc
            libsForQt5.yakuake
            sops

            #python311Full
            #temurin-jre-bin-18
            #dotnet-sdk_7
            #wget
            #rclone
            #firefox
            #libsForQt5.kdenlive
            #obs-studio
            #mullvad-vpn
            #transmission
            #vlc
            #spotify
            #otpclient # WinAuth alternative
            #wireguard-go
            #protonmail-bridge
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
        v22-11 = with pkgs.v22-11; [
            pcloud
        ];
    };

    # Name = Executable, Source, Target
    homeFiles = {
        # Scripts
        "autostart" = [true ../../../scripts/autostart ".scripts/autostart"];
        "nix-rebuild" = [true ../../../scripts/nix-rebuild ".scripts/nix-rebuild"];
        "nix-test" = [true ../../../scripts/nix-test ".scripts/nix-test"];
        # Dotfiles
        "nix-config" = [true ../../../dotfiles/config.nix ".config/nixpkgs/config.nix"];
        "kde-autostart" = [false ../../../dotfiles/kde/autostart/autostart.desktop ".config/autostart/autostart.desktop"];
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
    services.flatpak = {
        packages = [
            "flathub:app/com.github.tchx84.Flatseal//stable"
            "flathub:app/com.usebottles.bottles//stable"
        ];
        remotes = {
            "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
    };

    programs = {
        git = {
            enable = true;
            extraConfig = {
                core = { excludesfile = "${osConfig.customOptions.userFolder}/.gitignore"; };
                init = { defaultBranch = "main"; };
                pull = { rebase = "false"; };
            };
            userEmail = "jamieallen050401@gmail.com"; # Relocate to secrets.nix (imported in flake.nix from separate repo and made available as option)
            userName = "Jamie050401"; # Relocate to secrets.nix (imported in flake.nix from separate repo and made available as option)
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
                nix-rebuild = "${osConfig.customOptions.userFolder}/.scripts/nix-rebuild --hostName ${osConfig.customOptions.hostName}";
                nix-test = "${osConfig.customOptions.userFolder}/.scripts/nix-test --hostName ${osConfig.customOptions.hostName}";
            };
        };
    };

    home = {
        username = osConfig.customOptions.userName;
        homeDirectory = osConfig.customOptions.userFolder;
        packages = packages.v23-11 ++ packages.v22-11;
        file = pkgs.v23-11.lib.mapAttrs convertHomeFile homeFiles;
        stateVersion = "23.05";
    };
}
