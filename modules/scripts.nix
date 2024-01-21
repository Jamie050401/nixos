{ pkgs, config, ... }:

{
    system.activationScripts = {
        ageKey.text = ''
            storePath=$(nix-store --add-fixed sha256 "/.age/id")
            mkdir -p "${config.customOptions.userFolder}/.config/sops/age"
            ln -f -s $storePath "${config.customOptions.userFolder}/.config/sops/age/keys.txt"
        '';
    };
}
