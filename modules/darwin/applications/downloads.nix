{ config, ... }:

{
  home-manager.users.${config.custom.mainUser} =
    {
      config,
      pkgs,
      ...
    }:
    {
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
    };
}
