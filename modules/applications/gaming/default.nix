{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  options = lib.optionalAttrs (_class == "nixos") {
    custom.applications.gaming.enable = lib.mkEnableOption "gaming related accessories";
  };

  config = lib.mkMerge [
    {
      home-manager.users =
        lib.mkIf (_class == "darwin" || (_class == "nixos" && config.custom.applications.gaming.enable))
          {
            ${config.custom.mainUser}.imports = [ ./prismlauncher.nix ];
          };
    }
    (lib.optionalAttrs (_class == "nixos") (
      lib.mkIf config.custom.applications.gaming.enable {
        assertions = [
          {
            assertion = config.custom.desktop.enable;
            message = "Gaming option cannot be enabled without desktop enabled.";
          }
        ];

        home-manager.users.${config.custom.mainUser} = {
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
      }
    ))
  ];
}
