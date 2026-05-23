{
  osConfig,
  lib,
  pkgs,
  myPkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home.packages = with pkgs; [
    (spotify.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        zip
        unzip
      ];
      postInstall = (old.postInstall or "") + ''
        wrapProgram $out/bin/spotify \
        --set LD_PRELOAD "${myPkgs.spotify-adblock}/lib/libspotifyadblock.so" \
        --set XDG_SESSION_TYPE "x11" \
        --set GDK_BACKEND "x11"

        ${unzip}/bin/unzip -p $out/share/spotify/Apps/xpui.spa xpui-snapshot.js | sed 's/adsEnabled:\!0/adsEnabled:false/' > $out/share/spotify/Apps/xpui-snapshot.js
        ${zip}/bin/zip --junk-paths --update $out/share/spotify/Apps/xpui.spa $out/share/spotify/Apps/xpui-snapshot.js
        rm $out/share/spotify/Apps/xpui-snapshot.js
      '';
    }))
  ];
}
