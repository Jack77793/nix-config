{
  _class,
  lib,
  pkgs,
  ...
}:

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
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    channel.enable = false;
  }
  // lib.optionalAttrs (_class == "darwin") {
    enable = true;
    package = pkgs.nix;
  };

  nixpkgs.overlays = (import ../../pkgs).overlays;
  nixpkgs.config.allowUnfree = lib.mkDefault true;
}
