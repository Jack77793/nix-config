{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs.prismlauncher = {
    enable = true;
    package = (
      pkgs.prismlauncher.override {
        additionalPrograms = with pkgs; [
          glfw
        ];
        jdks = with pkgs; [
          zulu8
          zulu17
          zulu21
        ];
      }
    );
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
