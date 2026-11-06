args@{
  config,
  lib,
  pkgs,
  ...
}:

let
  prismRuntimeDirectory = "/run/user/${
    toString args.osConfig.users.users.${config.home.username}.uid
  }/prismlauncher";
in
{
  programs.prismlauncher = lib.mkMerge [
    {
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
      };
    }
    (lib.mkIf
      (pkgs.stdenv.hostPlatform.isLinux && (args.osConfig.custom.applications.gaming.enable or false))
      {
        settings = {
          EnableFeralGamemode = true;
          EnableMangoHud = true;
          JvmArgs = "-Djava.io.tmpdir=${prismRuntimeDirectory}";
          PreLaunchCommand = "mkdir -p ${prismRuntimeDirectory}";
          UseNativeGLFW = true;
          UseNativeOpenAL = true;
        };
      }
    )
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      settings = {
        EnableFeralGamemode = false;
        EnableMangoHud = false;
        JavaPath = "${pkgs.zulu}/bin/java";
        UseNativeGLFW = false;
        UseNativeOpenAL = false;
      };
      package = null;
    })
  ];
}
