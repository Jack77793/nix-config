{
  config,
  pkgs,
  options,
  ...
}:

let
  homeConfig = config.home-manager.users.${config.custom.mainUser};
in
{
  environment = {
    persistence."/nix/persist".directories = [
      "/var/lib/plocate"
    ];
    shellAliases = {
      locate = "locate --database /var/lib/plocate/plocate.db";
    };
  };

  home-manager.users.${config.custom.mainUser}.imports = [
    {
      programs = {
        bat.enable = true;

        eza = {
          enable = true;
          git = true;
          icons = "auto";
        };

        fastfetch = {
          enable = true;
          settings = {
            display.size.maxPrefix = "TB";
            modules = [
              "title"
              "separator"
              "os"
              "host"
              "kernel"
              "uptime"
              "packages"
              "shell"
              "display"
              "de"
              "wm"
              "terminal"
              "terminalfont"
              "cpu"
              "gpu"
              "memory"
              "swap"
              "disk"
              "localip"
              "battery"
              "poweradapter"
              "locale"
              "break"
              "colors"
            ];
          };
        };

        fzf.enable = true;

        htop = {
          enable = true;
          settings = {
            delay = 5;
            highlight_base_name = 1;
            show_cpu_frequency = 1;
            show_cpu_temperature = 1;
            show_cpu_usage = 1;
            show_program_path = 1;
          }
          // (
            with homeConfig.lib.htop;
            leftMeters [
              (bar "LeftCPUs2")
              (bar "CPU")
              (text "System")
              (text "Tasks")
            ]
          )
          // (
            with homeConfig.lib.htop;
            rightMeters [
              (bar "RightCPUs2")
              (bar "MemorySwap")
              (text "LoadAverage")
              (text "Uptime")
            ]
          );
        };

        jq.enable = true;
        ripgrep.enable = true;
        ripgrep-all.enable = config.custom.desktop.enable;
      };
    }
  ];

  services.locate = {
    enable = true;
    output = "/var/lib/plocate/plocate.db";
    package = pkgs.plocate;
    prunePaths = options.services.locate.prunePaths.default ++ [ "/home/.snapshots" ];
  };
}
