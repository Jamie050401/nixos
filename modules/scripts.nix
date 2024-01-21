{ pkgs, config, ... }:

{
    system.activationScripts = {
        sops-secrets = {
            text = ''
                storePath=$(nix-store --add-fixed sha256 "../secrets/secrets.yaml")
                mkdir "/.secrets"
                ln -s $storePath "/.secrets/secrets.yaml"
            '';
        };
    };
}
