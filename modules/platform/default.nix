{
  config,
  _class,
  lib,
  ...
}:

{
  imports = [
    ./nix.nix
  ]
  ++ lib.optionals (_class == "nixos") [
    ./boot.nix
    ./storage.nix
    ./hardware.nix
    ./locale.nix
    ./packages.nix
  ];

  config = lib.optionalAttrs (_class == "nixos") {
    nix.gc.dates = lib.mkIf config.custom.hostDefaults.enable "weekly";
  };
}
