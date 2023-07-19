
{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot = {
        initrd = {
            availableKernelModules = [
                "uhci_hcd"
                "ehci_pci"
                "ahci"
                "virtio_pci"
                "virtio_scsi"
                "sd_mod"
                "sr_mod"
            ];
            kernelModules = [
                # ...
            ];
        };
        kernelModules = [
            # ...
        ];
        extraModulePackages = [
            # ...
        ];
    };

    # TODO - Partition manually so that labels can be assigned (https://www.youtube.com/watch?v=AGVXJ-TIv3Y&t=6342s)
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/9793e870-055a-4348-abf2-2f32171b34d5";
        fsType = "ext4";
    };

    swapDevices = [
        { device = "/dev/disk/by-uuid/33838817-6e8a-4efe-8980-1ce0c93cb7f9"; }
    ];

    networking.useDHCP = lib.mkDefault = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}