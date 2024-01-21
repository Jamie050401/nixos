{
    description = "NixOS Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, ... }:
        let
            customOptions = {
                hostName = "nixos-mini-pc";
                userFolder = "/home/jamie";
                userName = "jamie";
            };

            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;
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
