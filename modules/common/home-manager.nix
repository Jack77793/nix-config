{ config, myVars, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit myVars; };

    users.${config.custom.mainUser}.home = {
      username = config.custom.mainUser;
      homeDirectory = config.users.users.${config.custom.mainUser}.home;
    };

    sharedModules = [
      {
        programs.home-manager.enable = true;
      }
    ];
  };
}
