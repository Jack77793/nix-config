{
  config,
  _class,
  lib,
  pkgs,
  ...
}:

let
  # Preserve standalone imports and Darwin, which do not declare this option.
  hostDefaults = config.custom.hostDefaults.enable or true;
in
lib.mkMerge [
  {
    nix = {
      settings = {
        substituters = [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirror.nju.edu.cn/nix-channels/store"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = lib.mkIf hostDefaults true;
      };
      gc = lib.mkIf hostDefaults {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      channel.enable = false;
    };

    nixpkgs.overlays = (import ../../pkgs).overlays;
    nixpkgs.config.allowUnfree = lib.mkDefault true;
  }
  (lib.optionalAttrs (_class == "nixos") {
    nix.gc.dates = lib.mkIf (config.custom.hostDefaults.enable or false) "weekly";
  })
  (lib.optionalAttrs (_class == "darwin") {
    nix = {
      enable = true;
      package = pkgs.nix;
    };
  })
]
