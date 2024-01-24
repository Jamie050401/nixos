{ config, ... }:

let
    pkgs = config.customOptions.pkgs;
in {
    system.activationScripts = {
        ageKey.text = ''
            PATH=$PATH:${pkgs.v23-11.lib.makeBinPath [ pkgs.v23-11.git ]}
            agePath=${config.customOptions.userFolder}/.age/id
            mkdir -p "${config.customOptions.userFolder}/.config/sops/age"
            ln -f -s $agePath "${config.customOptions.userFolder}/.config/sops/age/keys.txt"
        '';
    };
}
