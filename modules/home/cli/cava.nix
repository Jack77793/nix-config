{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      output.method = "ncurses";
      color = {
        gradient = 1;
        gradient_color_1 = "'#8FBCBB'";
        gradient_color_2 = "'#88C0D0'";
        gradient_color_3 = "'#81A1C1'";
        gradient_color_4 = "'#5E81AC'";
        gradient_color_5 = "'#B48EAD'";
        gradient_color_6 = "'#EBCB8B'";
        gradient_color_7 = "'#D08770'";
        gradient_color_8 = "'#BF616A'";
      };
    };
  };
}
