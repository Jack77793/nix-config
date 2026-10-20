{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../../../home/modules/applications/aria2.nix ];

  programs.aria2.settings.file-allocation = lib.mkForce "falloc";

  launchd.agents.aria2 = {
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
