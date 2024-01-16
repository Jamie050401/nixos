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
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;

            customOptions = {
                userName = "jamie";
                userFolder = "/home/jamie";
                hostName = "nixos-mini-pc";
            };
            options.customOptions = lib.mkOption {
                type = lib.types.set;
                default = customOptions;
            };
        in {
            nixosConfigurations = {
                ${customOptions.hostName} = lib.nixosSystem {
                    inherit system;
                    specialArgs = { inherit inputs; };
                    modules = [
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
