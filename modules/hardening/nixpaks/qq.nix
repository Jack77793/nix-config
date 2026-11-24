{
  lib,
  pkgs,
  qq,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  runCommandLocal,
}:

let
  appId = "com.qq.QQ";

  wrapped = mkNixPak {
    config =
      { config, sloth, ... }:
      {
        imports = [
          ./common.nix
        ];

        app = {
          package = qq;
          binPath = "bin/qq";
        };
        flatpak = {
          inherit appId;
        };

        desktopIntegration = {
          notifications = true;
          tray = true;
          mpris = true;
          accessibility = true;
        };
        portalGroups = {
          fileChooser = true;
          openUri = true;
          notifications = true;
          screenCast = true;
          camera = true;
          inhibit = true;
          inputMethod = true;
        };

        bubblewrap = {
          # QQ renders through Wayland but keeps X11 fallback for clipboard/window compatibility.
          sockets.x11 = true;
          # libdbus aborts without /etc/machine-id; provide a stable synthetic ID.
          bind.ro = [
            [
              (toString (
                pkgs.writeText "qq-machine-id" "${
                  builtins.substring 0 32 (builtins.hashString "sha256" config.flatpak.appId)
                }\n"
              ))
              "/etc/machine-id"
            ]
          ];
          env = {
            LANG = lib.mkForce "zh_CN.UTF-8";
            DISPLAY = sloth.envOr "DISPLAY" "";
            XAUTHORITY = sloth.envOr "XAUTHORITY" (sloth.concat' sloth.homeDir "/.Xauthority");
            # qq's nixpkgs wrapper runs versionConfigScript using coreutils and sed.
            PATH = lib.makeBinPath [
              pkgs.coreutils
              pkgs.gnused
            ];
          };
        };
      };
  };

  exe = lib.getExe wrapped.config.script;
  assets = runCommandLocal "qq-desktop-assets" { } ''
    mkdir -p $out/share
    ln -s ${qq}/share/icons $out/share/icons
  '';
in
buildEnv {
  inherit (wrapped.config.script) name passthru;
  meta = wrapped.config.script.meta // {
    mainProgram = "qq";
  };
  paths = [
    wrapped.config.script
    assets
    (makeDesktopItem {
      name = "qq";
      desktopName = "QQ";
      exec = "${exe} %U";
      icon = "qq";
      terminal = false;
      startupNotify = true;
      startupWMClass = "QQ";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      extraConfig.X-Flatpak = appId;
    })
  ];
}
