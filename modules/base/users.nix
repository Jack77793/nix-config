{
  config,
  lib,
  pkgs,
  myVars,
  _class,
  ...
}:

{
  options.custom = {
    mainUser = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "The primary user whose Home Manager configuration is managed";
    };
  }
  // lib.optionalAttrs (_class == "nixos") {
    defaultUser.enable = lib.mkEnableOption "default user";
  };

  config = lib.mkMerge [
    {
      _module.args.myVars = import ./vars.nix;
    }
    (lib.optionalAttrs (_class == "darwin") {
      custom.mainUser = lib.mkDefault config.system.primaryUser;
    })
    (lib.optionalAttrs (_class == "nixos") {
      users = lib.mkIf config.custom.defaultUser.enable {
        mutableUsers = false;
        users.${config.custom.mainUser} = {
          isNormalUser = true;
          initialHashedPassword = myVars.initialHashedPassword;
          uid = 1000;
          shell = lib.mkOverride 900 pkgs.zsh;
          home = "/home/${config.custom.mainUser}";
          extraGroups = lib.mkDefault myVars.usergroups;
          openssh.authorizedKeys.keys = myVars.sshKeys;
        };
      };
      custom.mainUser = lib.mkIf config.custom.defaultUser.enable (lib.mkDefault myVars.username);
    })
  ];
}
