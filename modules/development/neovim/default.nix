{ config, lib, ... }:

{
  options.custom.development.neovim.extended = lib.mkEnableOption "extended neovim";

  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    home-manager.users.${config.custom.mainUser} = {
      imports = [ ../../../home/modules/development/neovim ];
      custom.development.neovim.extended = config.custom.development.neovim.extended;
    };
  };
}
