{
  config,
  lib,
  pkgs,
  myVars,
  ...
}:

{
  options.custom = {
    defaultUser.enable = lib.mkEnableOption "default user";
  };

  config = lib.mkIf config.custom.defaultUser.enable {
    users = {
      mutableUsers = false;
      users.${config.custom.mainUser} = {
        isNormalUser = true;
        initialHashedPassword = myVars.initialHashedPassword;
        uid = 1000;
        shell = pkgs.zsh;
        home = "/home/${config.custom.mainUser}";
        extraGroups = myVars.usergroups;
        openssh.authorizedKeys.keys = myVars.sshKeys;
      };
    };
    custom.mainUser = lib.mkDefault myVars.username;
  };
}
