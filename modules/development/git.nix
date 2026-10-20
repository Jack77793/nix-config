{
  config,
  pkgs,
  myVars,
  ...
}:

{
  environment.systemPackages = [ pkgs.git ];

  home-manager.users.${config.custom.mainUser} = {
    imports = [ ../../home/modules/development/git.nix ];

    programs.git = {
      signing.key = "CAE07E085EB3F663";
      settings.user = {
        name = myVars.username;
        email = myVars.useremail;
      };
    };

    programs.gh.hosts."github.com".user = myVars.username;
  };
}
