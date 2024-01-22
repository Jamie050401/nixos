# My NixOS Configurations

## TODO
1. Move from X11 to Wayland
2. Look into including Xwayland Rootful
3. Add KDE dotfiles into home-manager
4. Get AppImage working
5. Get MEGASync working (maybe AppImage? retry the native nix package)
6. Migrate to AppImage version of pCloud
7. Update flake.nix to pull in sops secrets from separate repository (https://discourse.nixos.org/t/how-to-clone-and-access-a-git-repo-with-nix-flakes/13113)
8. Set user (jamie) password (read from file - secret in sops)
9. Set root password (read from file - secret in sops)

## NixOS Information

### /etc/nixos

This is the directory where the .nix configuration files exist.  

### Useful Commands

1. nixos-rebuild switch  
   - Rebuilds the NixOS configuration, switches to it and sets it as default from next boot.  
2. nixos-rebuild test  
   - Rebuilds the NixOS configuration, switches to it BUT, does not set it as new default.  
3. nixos-rebuild boot  
   - Rebuilds the NixOS configuration and sets it as default from next boot, without switching to it.  
4. nixos-rebuild build  
   - Only rebuilds the NixOS configuration.  
   - --upgrade  
     - The upgrade argument fetches the latest updates from active channels.  
   - --flake  .#{host}
     - Rebuilds using the flake.nix file for the specified host.  
     - If host is left blank, it will look for one that matches the systems hostname.  

5. nix-channel  
   - --list  
     - Lists currently active channels.  
   - --add {url} nixos  
     - Adds the desired url to active channels.  

6. age-keygen -o ~/.age/id
   - Generates an age private/public key pair

7. ssh-keygen
   - Generates an ssh private/public key pair
