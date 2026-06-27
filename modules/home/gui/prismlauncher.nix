{
  osConfig,
  lib,
  myVars,
  ...
}:

lib.mkIf osConfig.custom.extras.gaming.enable {
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
      IgnoreJavaWizard = true;
      JvmArgs = "-Djava.io.tmpdir=/run/user/${
        toString osConfig.users.users.${myVars.username}.uid
      }/prismlauncher";
      Language = "zh";
      PreLaunchCommand = "mkdir -p /run/user/${
        toString osConfig.users.users.${myVars.username}.uid
      }/prismlauncher";
      ShowConsole = true;
      TheCat = false;
      UseNativeGLFW = true;
      UseNativeOpenAL = true;
    };
  };
}
