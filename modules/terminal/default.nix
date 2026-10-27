{
  config,
  lib,
  _class,
  ...
}:

{
  imports = lib.optional (_class == "nixos") ./locate.nix;

  programs.zsh.enable = true;

  home-manager.users.${config.custom.mainUser} = {
    imports = [ ./home.nix ] ++ lib.optional config.custom.desktop.enable ./ghostty.nix;
    programs.ripgrep-all.enable = config.custom.desktop.enable;
  };
}
// (
  if _class == "nixos" then
    {
      environment.pathsToLink = [ "/share/zsh" ];
    }
  else
    {
      programs.ssh.extraConfig = ''
        AddKeysToAgent yes
      '';
    }
)
