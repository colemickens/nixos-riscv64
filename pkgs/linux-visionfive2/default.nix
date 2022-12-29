{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

buildLinux
  (args // {
    version = "6.1-rc5";

    src = fetchFromGitHub {
      owner = "starfive-tech";
      repo = "linux";
      # JH7110_VisionFive2_devel 2022/12/18
      # rev = "f0fce0037f9cc3fa6013d14d2f11fff7cf1a19da";
      # sha256 = "sha256-uPWDcP/svGnCXgLVTXUUpVLbWS2qx/FMP7g/0rhgqDg=";
      # JH7110_VisionFive2_upstream @ 2022/12/20
      rev = "df28f7ee82408669cf067c36466c5b4c96c3c5ed";
      sha256 = "sha256-yjIgLlsuYjOPv52m7pftkeGkiwFAFugFgzFvWK3ZBpU=";
    };

    # defconfig = "starfive_visionfive2_defconfig";
    defconfig = "defconfig";

    structuredExtraConfig = with lib.kernel; {
      SERIAL_8250_DW = yes;
      PINCTRL_STARFIVE = yes;

      # Doesn't build as a module
      DW_AXI_DMAC_STARFIVE = yes;

      # stmmac hangs when built as a module
      PTP_1588_CLOCK = yes;
      STMMAC_ETH = yes;
      STMMAC_PCI = yes;
    };
  }) // (args.argsOverride or { })
