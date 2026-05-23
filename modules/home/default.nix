{
  home-manager,
  myVars,
  myPkgs,
  nixfmt-rs,
  ...
}:

{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit myVars myPkgs nixfmt-rs;
    };

    users.${myVars.username} = {
      imports = [
        ./base
        ./cli
        ./gui
      ];
      programs.home-manager.enable = true;
      home = {
        username = myVars.username;
        homeDirectory = "/home/${myVars.username}";
      };
    };
  };
}
