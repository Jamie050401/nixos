{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ../global/configuration.nix
  ];

  # Manual (hardware-specific) adjustments for nixos-mini-pc
  networking.hostName = "nixos-mini-pc";
}
