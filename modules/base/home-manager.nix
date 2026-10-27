{
  config,
  myVars,
  home-manager,
  _class,
  ...
}:

{
  imports = [
    (
      if _class == "nixos" then
        home-manager.nixosModules.home-manager
      else
        home-manager.darwinModules.home-manager
    )
  ];

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
