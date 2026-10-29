{
  config,
  lib,
  _class,
  ...
}:

{
  home-manager.users.${config.custom.mainUser} = {
    imports = [ ./home.nix ];
  };
}
// lib.optionalAttrs (_class == "nixos") {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
