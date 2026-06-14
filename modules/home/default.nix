{
  config,
  home-manager,
  myVars,
  nixfmt-rs,
  ...
}:

{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit myVars nixfmt-rs;
    };

    users.${config.custom.mainUser} = {
      imports = [
        ./base
        ./cli
        ./gui
      ];
      programs.home-manager.enable = true;
      home = {
        username = config.custom.mainUser;
        homeDirectory = "/home/${config.custom.mainUser}";
      };
    };
  };
}
