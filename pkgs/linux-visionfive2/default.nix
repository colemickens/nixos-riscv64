{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  # last updated: 14-May-2023: https://github.com/starfive-tech/linux/tree/JH7110_VisionFive2_upstream
  version = "6.4-rc1";
  rev = "5067e82028046501daa6e0c53e8c54343a217f45";
  hash = "sha256-rydyJbSCsGZSjyL9r6D/HAj4VePssKM9GGE0834dBeI=";
in
buildLinux
  (args // {
    # https://github.com/starfive-tech/linux/tree/JH7110_VisionFive2_upstream
    inherit version;

    src = fetchFromGitHub {
      owner = "starfive-tech";
      repo = "linux";
      inherit rev hash;
    };

    # defconfig = "starfive_visionfive2_defconfig";
    # defconfig = "defconfig";
    defconfig = "jh7110_defconfig";

    structuredExtraConfig = with lib.kernel; {
      # SERIAL_8250_DW = yes;
      # PINCTRL_STARFIVE = yes;

      # TODO: maybe report? see if still an issue after next update
      PL330_DMA = no;

      # # Doesn't build as a module
      # DW_AXI_DMAC_STARFIVE = yes;

      # # stmmac hangs when built as a module
      # PTP_1588_CLOCK = yes;
      # STMMAC_ETH = yes;
      # STMMAC_PCI = yes;
    };
  }) // (args.argsOverride or { })
