# My NixOS Configurations

## TODO
1. Look into including Xwayland Rootful
2. Get AppImage working
3. Set user password (read from file - secret in sops)
4. Set root password (read from file - secret in sops)

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
