{ config, lib, ... }:

let
  homeConfig = config.home-manager.users.${config.custom.mainUser};
in
lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    {
      programs = {
        aria2 = {
          enable = true;
          settings = {
            bt-enable-lpd = true;
            bt-max-open-files = 256;
            bt-max-peers = 0;
            continue = true;
            dir = "${homeConfig.home.homeDirectory}/Downloads";
            enable-dht = true;
            enable-dht6 = true;
            enable-rpc = true;
            file-allocation = "falloc";
            max-concurrent-downloads = 16;
            max-connection-per-server = 16;
            min-split-size = "1M";
            peer-agent = "qBittorrent/4.5.2";
            peer-id-prefix = "-qB4520-";
            rpc-listen-all = true;
            rpc-listen-port = 6800;
            split = 64;
          };
          systemd.enable = true;
        };

        rclone.enable = true;

        yt-dlp = {
          enable = true;
          settings = {
            downloader = "aria2c";
            downloader-args = "aria2c:'-c -x16 -s16 -k1M'";
          };
        };
      };
    }
  ];
}
