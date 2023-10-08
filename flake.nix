{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;
        in {
            nixosConfigurations = {
                nixos-desktop = lib.nixosSystem {
                    inherit system;
                    modules = [
                        ./desktop/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                users.jamie = {
                                    imports = [
                                        ./desktop/home.nix
                                    ];
                                };
                            };
                        }
                    ];
                };

                nixos-server = lib.nixosSystem {
                    inherit system;
                    modules = [
                        ./server/configuration.nix
                    ];
                };
            };
        };
}
