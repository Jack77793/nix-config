{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  imports = lib.optional (_class == "nixos") ./locate.nix;

  config = lib.mkMerge [
    # Preserve the merge position of the shell defaults.
    (import ./shell {
      inherit
        config
        lib
        pkgs
        _class
        ;
    })
    {
      home-manager.users.${config.custom.mainUser} = {
        imports = [ ./home.nix ] ++ lib.optional config.custom.desktop.enable ./ghostty.nix;
        programs.ripgrep-all.enable = config.custom.desktop.enable;
      };
    }
    (lib.optionalAttrs (_class == "darwin") {
      programs.ssh.extraConfig = ''
        AddKeysToAgent yes
      '';
    })
  ];
}
