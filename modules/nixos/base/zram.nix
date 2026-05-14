{ lib, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = lib.mkDefault 100;
    memoryPercent = lib.mkDefault 50;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 160;
    "vm.watermark_boost_factor" = lib.mkDefault 0;
    "vm.watermark_scale_factor" = lib.mkDefault 125;
    "vm.page-cluster" = lib.mkDefault 0;
  };
}
