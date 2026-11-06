{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

let
  shell =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.zsh
    else
      config.users.users.${config.custom.mainUser}.shell;
  shellPath = if lib.isDerivation shell then "${shell}${shell.shellPath}" else shell;
  shellName = builtins.baseNameOf shellPath;
in
lib.mkMerge [
  {
    programs.zsh.enable = lib.mkDefault (shellName == "zsh");

    home-manager.users.${config.custom.mainUser}.programs = {
      bash.enable = lib.mkDefault (shellName == "bash");
      tmux.shell = lib.mkDefault shellPath;
      zsh.enable = lib.mkDefault (shellName == "zsh");
    };
  }
  (lib.optionalAttrs (_class == "nixos") {
    environment.pathsToLink = lib.mkIf config.programs.zsh.enable [ "/share/zsh" ];
  })
]
