{ pkgs, lib, config, ... }:

{
    system.activationScripts = {
        ageKey.text = ''
            PATH=$PATH:${lib.makeBinPath [ pkgs.nix pkgs.git ]}
            storePath=$(nix-store --add-fixed sha256 "${config.customOptions.userFolder}/.age/id")
            mkdir -p "${config.customOptions.userFolder}/.config/sops/age"
            ln -f -s $storePath "${config.customOptions.userFolder}/.config/sops/age/keys.txt"
        '';
    };
}
