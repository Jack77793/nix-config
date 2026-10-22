{ config, ... }:

{
  home-manager.users.${config.custom.mainUser}.home.stateVersion = config.custom.stateVersion;
}
