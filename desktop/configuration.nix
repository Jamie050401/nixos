#### Desktop configuration file for NixOS
#### Author: Jamie

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../global-configruation.nix
  ];

  #### Hardware
  hardware = {
    opengl = {
      extraPackages = [
        rocm-opencl-icd
        pkgs.amdvlk
      ];
      opengl.extraPackages32 = [
        pkgs.driversi686Linux.amdvlk
      ];
    };
  };

  #### Networking
  networking = {
    hostName = "nixos-desktop";
  };
}
