let
  inherit (import ../../../modules/base/vars.nix) username useremail;
in
{
  imports = [ ../../../home/modules/development/git.nix ];

  programs.git = {
    signing.key = "CAE07E085EB3F663";
    settings.user = {
      name = username;
      email = useremail;
    };
  };

  programs.gh.hosts."github.com".user = username;
}
