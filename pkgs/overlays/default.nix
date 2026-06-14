final: prev: {
  fwupd = (import ./fwupd) { inherit (prev) fwupd; };
  prismlauncher = (import ./prismlauncher) {
    inherit (prev)
      prismlauncher
      glfw
      zulu8
      zulu17
      zulu21
      ;
  };
  spotify = (import ./spotify) {
    inherit (prev)
      spotify
      zip
      unzip
      spotify-adblock
      ;
  };
}
