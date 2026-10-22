{ config, ... }:

{
  home-manager.users.${config.custom.mainUser} =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mpd = config.services.mpd;
      ncmpcppFifo = "${mpd.dataDir}/ncmpcpp.fifo";
      logDirectory = "${config.home.homeDirectory}/Library/Logs/mpd";
    in
    {
      home.packages = [ pkgs.mpc ];

      programs.mpv.config = {
        hwdec = "videotoolbox";
        vo = "gpu-next";
        ytdl-raw-options = "cookies-from-browser=chrome";
      };

      services.mpd = {
        musicDirectory = "${config.home.homeDirectory}/Music";
        extraConfig = ''
          audio_output {
              type "osx"
              name "MPD CoreAudio Output"
              mixer_type "software"
          }
          audio_output {
              type "fifo"
              name "MPD FIFO"
              path "${ncmpcppFifo}"
              format "44100:16:2"
          }
        '';
      };

      programs.ncmpcpp = {
        mpdMusicDir = mpd.musicDirectory;
        settings.visualizer_data_source = ncmpcppFifo;
      };

      home.activation.mpdDirectories = lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
        run ${pkgs.coreutils}/bin/mkdir -p ${
          lib.escapeShellArgs [
            mpd.musicDirectory
            mpd.dataDir
            mpd.playlistDirectory
            logDirectory
          ]
        }
      '';
    };
}
