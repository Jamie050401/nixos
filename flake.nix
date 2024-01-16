{
    description = "NixOS Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix.url = "github:Mic92/sops-nix";
    };

    outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
        let
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
                        ./nixos-mini-pc/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                users.jamie = {
                                    imports = [
                                        sops-nix.homeManagerModules.sops
                                        ./global/home.nix
                                    ];
                                };
                            };
                        }
                    ];
                };
            };
        };
}
