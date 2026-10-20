{ config, ... }:

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
        with config.lib.htop;
        leftMeters [
          (bar "LeftCPUs2")
          (bar "CPU")
          (text "System")
          (text "Tasks")
        ]
      )
      // (
        with config.lib.htop;
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
  };
}
