{ lib, config, ... }:

let
    pkgs = config.customOptions.pkgs.v23-11;
in {
    system.activationScripts = {
        ageKey.text = ''
            PATH=$PATH:${lib.makeBinPath [ pkgs.git ]}
            agePath=${config.customOptions.userFolder}/.age/id
            mkdir -p "${config.customOptions.userFolder}/.config/sops/age"
            ln -f -s $agePath "${config.customOptions.userFolder}/.config/sops/age/keys.txt"
        '';
    };
}
