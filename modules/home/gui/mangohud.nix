{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.extras.gaming.enable {
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      procmem = true;
      proc_vram = true;
      fps = true;
      frametime = true;
      throttling_status = true;
      frame_timing = true;
      text_outline = true;
      font_file = "${pkgs.nerd-fonts.iosevka-term}/share/fonts/truetype/NerdFonts/IosevkaTerm/IosevkaTermNerdFont-Bold.ttf";
    };
  };
}
