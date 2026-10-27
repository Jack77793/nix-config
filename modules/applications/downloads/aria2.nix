{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.aria2 = {
    enable = true;
    systemd.enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      bt-enable-lpd = true;
      bt-max-open-files = 256;
      bt-max-peers = 0;
      continue = true;
      dir = "${config.home.homeDirectory}/Downloads";
      enable-dht = true;
      enable-dht6 = true;
      enable-rpc = true;
      file-allocation = lib.mkDefault "falloc";
      max-concurrent-downloads = 16;
      max-connection-per-server = 16;
      min-split-size = "1M";
      peer-agent = "qBittorrent/4.5.2";
      peer-id-prefix = "-qB4520-";
      rpc-listen-all = true;
      rpc-listen-port = 6800;
      split = 64;
    };
  };

  launchd.agents.aria2 = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.aria2}/bin/aria2c"
        "--conf-path=${config.xdg.configHome}/aria2/aria2.conf"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
