final: prev: rec {
  riscv64 = rec {
    meta-sifive = final.callPackage ./meta-sifive { };

    firefox = final.callPackage ./firefox { };

    # QEMU
    sd-image-qemu = final.callPackage ./sd-image-qemu { };
    sd-image-qemu-sway = final.callPackage ./sd-image-qemu-sway { };

    # HiFive Unmatched
    sd-image-unmatched = final.callPackage ./sd-image-unmatched { };

    linux_unmatched = final.callPackage ./linux-unmatched { };
    linuxPackages_unmatched = final.linuxPackagesFor linux_unmatched;
    uboot-unmatched = final.callPackage ./uboot-unmatched { };
    uboot-unmatched-spi-image = final.callPackage ./uboot-unmatched-spi-image { };
    uboot-unmatched-spi-installer = final.callPackage ./uboot-unmatched-spi-installer { };

    linux = final.lib.warn "riscv64.linux is deprecated. For HiFive Unmatched, use riscv64.linux_unmatched." linux_unmatched;
    linuxPackages = final.lib.warn "riscv64.linuxPackages is deprecated. For HiFive Unmatched, use riscv64.linuxPackages_unmatched." linuxPackages_unmatched;

    # StarFive VisionFive
    sd-image-visionfive = final.callPackage ./sd-image-visionfive { };

    linux_visionfive = final.callPackage ./linux-visionfive {
      kernelPatches = with final.kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
    };
    linux_visionfive2 = final.callPackage ./linux-visionfive2 {
      kernelPatches = with final.kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
    };
    linuxPackages_visionfive = final.linuxPackagesFor linux_visionfive;
    linuxPackages_visionfive2 = final.linuxPackagesFor linux_visionfive2;
  };

  unmatched = final.lib.warn "The unmatched attribute is deprecated. Use riscv64 instead." riscv64;
}
