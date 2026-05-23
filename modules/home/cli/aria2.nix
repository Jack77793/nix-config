{
  config,
  osConfig,
  lib,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs.aria2 = {
    enable = true;
    settings = {
      bt-enable-lpd = true;
      bt-max-open-files = 256;
      bt-max-peers = 0;
      continue = true;
      dir = "${config.home.homeDirectory}/Downloads";
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
}
