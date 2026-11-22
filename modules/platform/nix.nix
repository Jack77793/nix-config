{
  config,
  _class,
  lib,
  pkgs,
  ...
}:

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
        auto-optimise-store = lib.mkDefault true;
      };
      gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 7d";
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
