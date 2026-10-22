{ config, pkgs, ... }:

{
  home-manager.users.${config.custom.mainUser} = {
    imports = [ ../../home/applications/prismlauncher.nix ];

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
  };
}
