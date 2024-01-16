{
    description = "NixOS Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager }:
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
                nixos-mini-pc = lib.nixosSystem {
                    inherit system;
                    specialArgs = { inherit customOptions; };
                    modules = [
                        ./modules/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                users.jamie = { # ${customOptions.userName}
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
