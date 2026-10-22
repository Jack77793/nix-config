{ config, lib, ... }:

{
  options.custom.development.neovim.extended = lib.mkEnableOption "extended neovim";

  config.home-manager.users.${config.custom.mainUser} = {
    imports = [
      ../home/development/git.nix
      ../home/development/neovim
    ]
    ++ lib.optionals config.custom.desktop.enable [
      ../home/development/uv.nix
      ../home/development/agents/codex.nix
      ../home/development/agents/pi.nix
    ];

    custom.development.neovim.extended = config.custom.development.neovim.extended;
  };
}
