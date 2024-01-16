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
            userName = "jamie";
            userFolder = "/home/jamie";

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
                    modules = [
                        ./devices/nixos-mini-pc/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                users.${userName} = {
                                    imports = [
                                        ./devices/nixos-mini-pc/home.nix
                                    ];
                                };
                            };
                        }
                    ];
                };
            };
        };
}
