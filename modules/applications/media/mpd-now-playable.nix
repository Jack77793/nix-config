{
  config,
  lib,
  pkgs,
  ...
}:

let
  mpd = config.services.mpd;
  logDirectory = "${config.home.homeDirectory}/Library/Logs/mpd-now-playable";
  settingsFile = (pkgs.formats.toml { }).generate "mpd-now-playable.toml" {
    mpd = {
      host = if mpd.network.listenAddress == "any" then "127.0.0.1" else mpd.network.listenAddress;
      port = mpd.network.port;
      music_directory = mpd.musicDirectory;
    };
    receivers = [ { kind = "cocoa"; } ];
  };
in
lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && mpd.enable) {
  home.packages = [ pkgs.mpd-now-playable ];

  xdg.configFile."mpd-now-playable/config.toml".source = settingsFile;

  home.activation.mpdNowPlayableDirectories =
    lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "writeBoundary" ]
      ''
        run ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg logDirectory}
      '';

  launchd.agents.mpd-now-playable = {
    enable = true;
    domain = "gui";
    restartTriggers = [ config.xdg.configFile."mpd-now-playable/config.toml".source ];
    config = {
      ProgramArguments = [ (lib.getExe pkgs.mpd-now-playable) ];
      EnvironmentVariables = {
        XDG_CONFIG_HOME = config.xdg.configHome;
        PYTHONUNBUFFERED = "1";
      };
      KeepAlive = true;
      RunAtLoad = true;
      ThrottleInterval = 30;
      ProcessType = "Interactive";
      StandardOutPath = "${logDirectory}/stdout.log";
      StandardErrorPath = "${logDirectory}/stderr.log";
    };
  };
}
