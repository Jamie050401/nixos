{ pkgs, config, ... }:

{
    system.activationScripts = {
        ageKey.text = ''
            mkdir -p "${config.customOptions.userFolder}/.config/sops/age"
            ln -f -s "/.age/id" "${config.customOptions.userFolder}/.config/sops/age/keys.txt"
        '';
    };
}
