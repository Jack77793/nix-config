_final: prev:

prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  mpd-now-playable = prev.callPackage ../mpd-now-playable { };
}
