{
  imports = [
    ./tools.nix
    ./packages.nix
  ];

  environment.pathsToLink = [ "/share/zsh" ];
}
