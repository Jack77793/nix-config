{
  imports = [
    ../../../home/modules/applications/documents.nix
    ../../../home/modules/applications/downloads.nix
    ../../../home/modules/terminal/packages.nix
    ../../../home/modules/terminal/tools.nix
    ../../../home/modules/terminal/tmux.nix
    ../../../home/modules/development/uv.nix
    ../../../home/modules/security/gpg.nix
    ./aria2.nix
    ./codex.nix
    ./ghostty.nix
    ./git.nix
    ./mpv.nix
    ./nvim.nix
    ./pi.nix
    ./zsh.nix
  ];

  programs.ripgrep-all.enable = true;
}
