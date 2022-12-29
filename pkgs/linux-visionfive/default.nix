{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

buildLinux (args // {
  version = "6.1-rc6";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "linux";
    # "visionfive" 2022/12/23
    rev = "a8319390ca6e3f7badfbfc8fcae718546818e27c";
    sha256 = "sha256-7vE5Y7/TqGiwVu2QNzMOQMUcSi9nIC/5CeaUK3Ce+q8=";
  };

  defconfig = "starfive_jh7100_fedora_defconfig";

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
}) // (args.argsOverride or {})
