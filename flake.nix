{
    description = "NixOS Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-22-11.url = "github:nixos/nixpkgs/nixos-22.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    };

    outputs = inputs@{ self, nixpkgs, nixpkgs-22-11, home-manager, sops-nix, flatpaks, ... }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            pkgs-22-11 = import nixpkgs-22-11 {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;

            customOptions = {
                hostName = "nixos-mini-pc";
                pkgs-22-11 = pkgs-22-11;
                userFolder = "/home/jamie";
                userName = "jamie";
            };
        in {
            nixosConfigurations = {
                ${customOptions.hostName} = lib.nixosSystem {
                    inherit system;
                    specialArgs = { inherit inputs; };
                    modules = [
                        # Options (available in config)
                        ({ lib, ... }: {
                            options.customOptions = lib.mkOption {
                                type = lib.types.attrs;
                                default = customOptions;
                            };
                        })

                        # Configurations
                        sops-nix.nixosModules.sops
                        ./modules/${customOptions.hostName}/hardware-configuration.nix
                        ./modules/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                users.${customOptions.userName} = {
                                    imports = [
                                        flatpaks.homeManagerModules.default
                                        ./modules/users/${customOptions.userName}/home.nix
                                    ];
                                };
                            };
                        }
                    ];
                };
            };
        };
}
