{
  config,
  lib,
  _class,
  ...
}:

{
  options.custom.development.neovim.extended = lib.mkEnableOption "extended neovim";

  config = {
    home-manager.users.${config.custom.mainUser} = {
      imports = [ ./home.nix ];
      custom.development.neovim.extended = config.custom.development.neovim.extended;
    };
  }
  // (
    if _class == "nixos" then
      {
        programs.neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };
      }
    else
      {
        custom.development.neovim.extended = lib.mkDefault true;
      }
  );
}
