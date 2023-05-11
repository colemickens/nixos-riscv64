# TODO: Consolidate with sd-image-riscv64-unmatched

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/profiles/installation-device.nix")
    ./sd-image.nix # contains VisionFive-specific hacks
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelParams = ["console=tty0" "console=ttyS0,115200n8"];

  installer.cloneConfig = false;

  sdImage = {
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
      cp ${./uEnv.txt} ./files/boot/uEnv.txt
    '';
  };
}
