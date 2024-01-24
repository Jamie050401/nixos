{
    description = "NixOS Flake";

    inputs = {
        nixpkgs-v23-11.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-v22-11.url = "github:nixos/nixpkgs/nixos-22.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs-v23-11";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs-v23-11";
        };
        flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    };

    outputs = inputs@{ self, nixpkgs-v23-11, nixpkgs-v22-11, home-manager, sops-nix, flatpaks, ... }:
        let
            system = "x86_64-linux";
            pkgs = {
                v23-11 = import nixpkgs-v23-11 { inherit system; config.allowUnfree = true; };
                v22-11 = import nixpkgs-v22-11 { inherit system; config.allowUnfree = true; };
            };
            lib = nixpkgs-v23-11.lib;

            customOptions = {
                hostName = "nixos-mini-pc";
                gitName = "Jamie050401";
                pkgs = pkgs;
                userName = "jamie";
                userFolder = "/home/jamie";
                userEmail = "jamieallen050401@gmail.com";
            };
        in {
            nixosConfigurations = {
                ${customOptions.hostName} = lib.nixosSystem {
                    inherit system;
                    specialArgs = { inherit inputs; };
                    modules = [
                        ({ lib, ... }: {
                            options = {
                                customOptions = lib.mkOption {
                                    type = lib.types.attrs;
                                    default = customOptions;
                                };
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
