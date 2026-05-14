{ config, ... }:

{
  programs.htop = {
    enable = true;
    settings = {
      show_program_path = 1;
      highlight_base_name = 1;
      show_cpu_usage = 1;
      show_cpu_frequency = 1;
      show_cpu_temperature = 1;
      delay = 5;
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
}
