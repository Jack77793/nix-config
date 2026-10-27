{
  config,
  lib,
  _class,
  ...
}:

{
  imports = [
    ./packages.nix
    ./gaming
  ]
  ++ lib.optionals (_class == "nixos") [
    ./qbittorrent.nix
    ./browser.nix
    ./mail.nix
  ];

  home-manager.users.${config.custom.mainUser}.imports = lib.optionals config.custom.desktop.enable [
    ./documents.nix
    ./downloads/home.nix
    ./media/home.nix
  ];
}
