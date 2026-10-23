{
  config,
  lib,
  pkgs,
  home-manager,
  myVars,
  ...
}:

{
  imports = [
    home-manager.nixosModules.home-manager
    ../../../common/users.nix
    ../../../common/home-manager.nix
  ];

  custom.mainUser = lib.mkDefault myVars.username;

  users = {
    mutableUsers = false;
    users.${config.custom.mainUser} = {
      isNormalUser = true;
      group = "users";
      home = lib.mkDefault "/home/${config.custom.mainUser}";
      linger = true;
      hashedPassword = lib.mkDefault "!";
    };
  };

  services.dbus.enable = true;

  home-manager = {
    enableLegacyProfileManagement = false;
    users.${config.custom.mainUser} = {
      imports = [ ../../../home/development/agents/sandbox.nix ];
      home.stateVersion = config.system.stateVersion;
      programs.home-manager.enable = true;
    };
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixPath = [ "nixpkgs=${pkgs.path}" ];
  };
}
