{
  osConfig,
  lib,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
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
      EnableFeralGamemode = true;
      EnableMangoHud = true;
      IconTheme = "flat";
      ShowConsole = true;
      TheCat = false;
      UseNativeGLFW = true;
      UseNativeOpenAL = true;
    };
  };
}
