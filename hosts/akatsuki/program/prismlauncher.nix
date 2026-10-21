{ pkgs, ... }:

{
  imports = [ ../../../home/modules/applications/prismlauncher.nix ];

  programs.prismlauncher = {
    package = null;
    settings = {
      EnableFeralGamemode = false;
      EnableMangoHud = false;
      JavaPath = "${pkgs.zulu}/bin/java";
      UseNativeGLFW = false;
      UseNativeOpenAL = false;
    };
  };
}
