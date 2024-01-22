{ pkgs, lib, config, ... }:

{
#    system.activationScripts = {
#        ageKey.text = ''
#            source ${config.system.build.setEnvironment}
#            storePath=$(nix-store --add-fixed sha256 "${config.customOptions.userFolder}/.age/id")
#            mkdir -p "${config.customOptions.userFolder}/.config/sops/age"
#            ln -f -s $storePath "${config.customOptions.userFolder}/.config/sops/age/keys.txt"
#        '';
#    };
}
