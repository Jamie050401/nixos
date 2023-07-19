{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    };

    outputs = { self, nixpkgs }: {
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };

            lib = nixpkgs.lib
        in {
            nixosConfigurations = {
                nixos-desktop = lib.nixosSystem {
                    inherit system;
                    modules = [
                        ./desktop/configuration.nix
                    ];
                };
            };
        };
    };
}
