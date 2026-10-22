{ pkgs, ... }:

{
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    bindings = [
      {
        command = "previous_column";
        key = "h";
      }
      {
        command = "scroll_down";
        key = "j";
      }
      {
        command = "scroll_up";
        key = "k";
      }
      {
        command = "next_column";
        key = "l";
      }
      {
        command = "page_up";
        key = "ctrl-u";
      }
      {
        command = "page_down";
        key = "ctrl-d";
      }
    ];
    settings = {
      clock_display_seconds = true;
      display_volume_level = true;
      external_editor = "nvim";
      mpd_host = "127.0.0.1";
      mpd_port = 6600;
      use_console_editor = true;
      user_interface = "alternative";
      visualizer_in_stereo = true;
      visualizer_look = "+|";
      visualizer_output_name = "MPD FIFO";
      visualizer_type = "spectrum";
    };
  };
}
