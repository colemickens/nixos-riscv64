let
  # Used by Zhaofeng
  defaultPkgs = import ../nixpkgs {
    config.allowBroken = true;
    overlays = [ (import ../pkgs) ];
  };
in

{ pkgs ? defaultPkgs }:

with builtins;

let
  makeWorld = name: contents: pkgs.writeText name (concatStringsSep "\n" contents);

  simpleSystem = (pkgs.nixos {
    imports = [
      # All utilities in installer images
      (pkgs.path + "/nixos/modules/profiles/base.nix")
      (pkgs.path + "/nixos/modules/profiles/installation-device.nix")
    ];

    fileSystems."/".device = "fake";
    boot.loader.grub.enable = false;
    networking.useDHCP = false;
    networking.useNetworkd = true;
    services.openssh.enable = true;

    system.stateVersion = "23.05";
  }).config.system.build.toplevel;

  graphicalSystem = (pkgs.nixos {
    fileSystems."/".device = "fake";
    boot.loader.grub.enable = false;
    services.xserver.enable = true;
    programs.sway.enable = true;

    # imake/xorg-cf-files doesn't have riscv64 definitions merged
    programs.ssh.askPassword = "";

    system.stateVersion = "23.05";
  }).config.system.build.toplevel;

  cachedLinuxPackagesFor = linuxPackages: map (p: linuxPackages.${p})
    [ "kernel" "zfs" ];
in {
  # Tier 0: Nix, toolchains, etc.
  tier0 = makeWorld "tier0" (with pkgs; [
    nix git stdenv gcc rustc llvmPackages.clang
  ]);

  # Tier 1: Basic system closure and various utilities
  tier1 = makeWorld "tier1" (with pkgs; [
    simpleSystem

    grub2

    cargo doxygen
    gnupg gpgme pcsclite
    gptfdisk udisks
    mdadm
    polkit xdg-utils
    usbutils pciutils mtdutils
    nfs-utils
    patchutils
    util-linux pv lsof
    htop iotop iftop
    lm_sensors
    screen tmux
    vim wget jq pfetch file
    p7zip libarchive
    fish zsh

    zfs zfsUnstable

    go tailscale
  ] ++ cachedLinuxPackagesFor riscv64.linuxPackages_unmatched
    ++ cachedLinuxPackagesFor riscv64.linuxPackages_visionfive
    ++ cachedLinuxPackagesFor linuxPackages
    ++ cachedLinuxPackagesFor linuxPackages_5_15
  );

  # Tier 2: Desktop-related and other interesting packages
  tier2 = makeWorld "tier2" (with pkgs; [
    graphicalSystem

    pulseaudio pavucontrol
    mesa-demos
    lynx netsurf.browser
    xterm alacritty kitty
    waypipe
    grim slurp wdisplays
    superTuxKart
    mstflint

    riscv64.firefox
  ]);

  inherit simpleSystem;
}
