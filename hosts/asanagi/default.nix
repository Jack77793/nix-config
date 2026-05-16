{
  nixfmt-rs,
  impermanence,
  home-manager,
  myVars,
  myPkgs,
  pkgs,
  ...
}:

{
  imports = [
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager

    ../../modules/nixos/base
    ../../modules/nixos/desktop

    ./hardware-configuration.nix
  ];

  networking.hostName = "Asanagi";

  users = {
    mutableUsers = false;
    users.${myVars.username} = {
      isNormalUser = true;
      initialHashedPassword = myVars.initialHashedPassword;
      shell = pkgs.zsh;
      home = "/home/${myVars.username}";
      extraGroups = myVars.usergroups;
      openssh.authorizedKeys.keys = myVars.sshKeys;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit myVars myPkgs nixfmt-rs;
    };

    users.${myVars.username} = {
      imports = [
        ../../modules/home/base
        ../../modules/home/cli
        ../../modules/home/gui
      ];
      programs.home-manager.enable = true;
      home = {
        username = myVars.username;
        homeDirectory = "/home/${myVars.username}";

        stateVersion = "25.11";
      };
    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
