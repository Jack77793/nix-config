{
  config,
  lib,
  pkgs,
  myVars,
  ...
}:

lib.mkIf config.custom.defaultUser.enable {
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
}
