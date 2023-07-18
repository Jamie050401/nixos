# README

...

## NixOS Information

### /etc/nixos

This is the directory where the .nix configuration files exist.

### Useful Commands

nixos-rebuild switch | Rebuilds the NixOS configuration, switches to it and sets it as default from next boot.
nixos-rebuild test   | Rebuilds the NixOS configuration, switches to it BUT, does not set it as new default.
nixos-rebuild boot   | Rebuilds the NixOS configuration and sets it as default from next boot, without switching to it.
nixos-rebuild build  | Only rebuilds the NixOS configuration.
  --upgrade          | The upgrade argument fetches the latest updates from active channels.

nix-channel
  --list             | Lists currently active channels.
  --add {url} nixos  | Adds the desired url to active channels.
