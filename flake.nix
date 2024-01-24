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
                pkgs = pkgs;
                
                userFolder = "/home/jamie";
                userName = "jamie";

                users = {
                    jamie = {
                        userFolder = "/home/jamie";
                        secrets = {
                            # Non-credential secrets only (since these will be available in the nix store)
                            # User secrets read in from external source ...
                        };
                    };
                };
            };

            createUserEnvironment = userName: userData: {
                # TODO - Update 'currentUser'
                ${userName} = {
                    imports = [
                        flatpaks.homeManagerModules.default
                        ./modules/users/${userName}/home.nix
                    ];
                };
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

                            # This option is only used by home-manager to track which user is currently being created
                            options.customOptions.users.currentUser = lib.mkOption {
                                type = lib.types.string;
                                default = "";
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
                                #users = {
                                #    lib.mapAttrs createUserEnvironment customOptions.users
                                #};
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
