{ _class, lib, ... }:

{
  imports = [
    ./base
    ./platform
    ./desktop
    ./terminal
    ./development
    ./applications
    ./security
  ]
  ++ lib.optionals (_class == "nixos") [
    ./networking
    ./virtualization
  ];
}
