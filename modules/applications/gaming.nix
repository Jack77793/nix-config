{
  config,
  lib,
  pkgs,
  myVars,
  ...
}:

{
  options.custom.extras.gaming.enable = lib.mkEnableOption "gaming related accessories";

  config = lib.mkIf config.custom.extras.gaming.enable {
    assertions = [
      {
        assertion = config.custom.desktop.enable;
        message = "Gaming option cannot be enabled without desktop enabled.";
      }
    ];

    home-manager.users.${config.custom.mainUser}.imports = [
      {
        home.packages = with pkgs; [
          gnome-mines
          gnome-sudoku
          mindustry-wayland
          osu-lazer-bin
        ];

        programs = {
          mangohud = {
            enable = true;
            settings = {
              cpu_mhz = true;
              cpu_power = true;
              cpu_stats = true;
              cpu_temp = true;
              font_file = "${pkgs.nerd-fonts.iosevka-term}/share/fonts/truetype/NerdFonts/IosevkaTerm/IosevkaTermNerdFont-Bold.ttf";
              fps = true;
              frame_timing = true;
              frametime = true;
              gpu_core_clock = true;
              gpu_stats = true;
              gpu_temp = true;
              proc_vram = true;
              procmem = true;
              text_outline = true;
              throttling_status = true;
            };
          };

          prismlauncher = {
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
                toString config.users.users.${myVars.username}.uid
              }/prismlauncher";
              Language = "zh";
              PreLaunchCommand = "mkdir -p /run/user/${
                toString config.users.users.${myVars.username}.uid
              }/prismlauncher";
              ShowConsole = true;
              TheCat = false;
              UseNativeGLFW = true;
              UseNativeOpenAL = true;
            };
          };
        };
      }
    ];

    programs = {
      gamescope = {
        # args = [];
        enable = true;
      };

      steam = {
        enable = true;
        extest.enable = true;
        fontPackages = with pkgs; [ sarasa-gothic ];
        protontricks.enable = true;
      };
    };
  };
}
