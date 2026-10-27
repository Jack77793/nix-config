{ lib, pkgs, ... }:

{
  programs.prismlauncher = {
    enable = true;
    settings = {
      ApplicationTheme = "system";
      AutoCloseConsole = true;
      AutomaticJavaDownload = false;
      AutomaticJavaSwitch = true;
      CloseAfterLaunch = false;
      ConsoleFont = "sans-serif";
      ConsoleFontSize = 13;
      IconTheme = "flat";
      IgnoreJavaWizard = true;
      Language = "zh";
      ShowConsole = true;
      TheCat = false;
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      EnableFeralGamemode = false;
      EnableMangoHud = false;
      JavaPath = "${pkgs.zulu}/bin/java";
      UseNativeGLFW = false;
      UseNativeOpenAL = false;
    };
  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    package = null;
  };
}
