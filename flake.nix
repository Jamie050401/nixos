{
    description = "NixOS Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }:
        let
            customOptions = {
                userName = "jamie";
                userFolder = "/home/jamie";
                hostName = "nixos-mini-pc";
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
                        ./modules/${customOptions.hostName}/hardware-configuration.nix
                        ./modules/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                users.${customOptions.userName} = {
                                    imports = [
                                        ./modules/home.nix
                                    ];
                                };
                            };
                        }
                    ];
                };
            };
        };
}
