{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

let
  shell = if _class == "nixos" then config.users.users.${config.custom.mainUser}.shell else pkgs.zsh;
  shellPath = if lib.isDerivation shell then "${shell}${shell.shellPath}" else shell;
  shellName = builtins.baseNameOf shellPath;
in
{
  imports = lib.optional (_class == "nixos") ./locate.nix;

  programs.zsh.enable = lib.mkDefault (shellName == "zsh");

  home-manager.users.${config.custom.mainUser} = {
    imports = [ ./home.nix ] ++ lib.optional config.custom.desktop.enable ./ghostty.nix;
    programs.zsh.enable = lib.mkDefault (shellName == "zsh");
    programs.bash.enable = lib.mkDefault (shellName == "bash");
    programs.tmux.shell = lib.mkDefault shellPath;
    programs.ripgrep-all.enable = config.custom.desktop.enable;
  };
}
// (
  if _class == "nixos" then
    {
      environment.pathsToLink = lib.mkIf config.programs.zsh.enable [ "/share/zsh" ];
    }
  else
    {
      programs.ssh.extraConfig = ''
        AddKeysToAgent yes
      '';
    }
)
