{ _class, lib, ... }:

{
  imports = [ ./fonts.nix ];

  options.custom.desktop.enable =
    lib.mkEnableOption "desktop applications and related configuration"
    // {
      default = _class == "darwin";
    };
}
