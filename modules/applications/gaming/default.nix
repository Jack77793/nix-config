{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

let
  prismRuntimeDirectory = "/run/user/${
    toString config.users.users.${config.custom.mainUser}.uid
  }/prismlauncher";
in
{
  options = lib.optionalAttrs (_class == "nixos") {
    custom.applications.gaming.enable = lib.mkEnableOption "gaming related accessories";
  };

  config =
    if _class == "darwin" then
      {
        home-manager.users.${config.custom.mainUser}.imports = [ ./prismlauncher.nix ];
      }
    else
      lib.mkIf config.custom.applications.gaming.enable {
        assertions = [
          {
            assertion = config.custom.desktop.enable;
            message = "Gaming option cannot be enabled without desktop enabled.";
          }
        ];

        home-manager.users.${config.custom.mainUser} = {
          imports = [ ./prismlauncher.nix ];
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
              settings = {
                EnableFeralGamemode = true;
                EnableMangoHud = true;
                JvmArgs = "-Djava.io.tmpdir=${prismRuntimeDirectory}";
                PreLaunchCommand = "mkdir -p ${prismRuntimeDirectory}";
                UseNativeGLFW = true;
                UseNativeOpenAL = true;
              };
            };
          };
        };

        programs = {
          gamescope.enable = true;

          steam = {
            enable = true;
            extest.enable = true;
            fontPackages = with pkgs; [ sarasa-gothic ];
            protontricks.enable = true;
          };
        };
      };
}
