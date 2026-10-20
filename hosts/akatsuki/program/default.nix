{
  imports = [
    ../../../home/modules/terminal/packages.nix
    ../../../home/modules/terminal/tools.nix
    ../../../home/modules/terminal/tmux.nix
    ../../../home/modules/development/uv.nix
    ../../../home/modules/security/gpg.nix
    ./aria2.nix
    ./codex.nix
    ./ghostty.nix
    ./git.nix
    ./nvim.nix
    ./pi.nix
    ./zsh.nix
  ];
}
