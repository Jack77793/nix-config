{
  lib,
  pkgs,
  wechat,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  runCommandLocal,
}:

let
  appId = "com.tencent.WeChat";

  wrapped = mkNixPak {
    config =
      { config, sloth, ... }:
      {
        imports = [
          ./common.nix
        ];

        app = {
          package = wechat;
          binPath = "bin/wechat";
        };
        flatpak = {
          inherit appId;
        };

        desktopIntegration = {
          notifications = true;
          tray = true;
        };
        portalGroups = {
          fileChooser = true;
          openUri = true;
          notifications = true;
          screenCast = true;
          camera = true;
          inputMethod = true;
        };

        bubblewrap = {
          sockets.x11 = true;
          # libdbus aborts without /etc/machine-id; provide a stable synthetic ID.
          bind.ro = [
            [
              (toString (
                pkgs.writeText "wechat-machine-id" "${
                  builtins.substring 0 32 (builtins.hashString "sha256" config.flatpak.appId)
                }\n"
              ))
              "/etc/machine-id"
            ]
          ];
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.appDataDir "/wechat"))
              (sloth.concat' sloth.xdgDataHome "/wechat")
            ]
          ];
          env = {
            HOME = lib.mkForce (sloth.concat' sloth.xdgDataHome "/wechat");
            LANG = lib.mkForce "zh_CN.UTF-8";
            DISPLAY = sloth.envOr "DISPLAY" "";
            XAUTHORITY = sloth.envOr "XAUTHORITY" (sloth.concat' sloth.homeDir "/.Xauthority");
            PATH = lib.makeBinPath [ pkgs.coreutils ];
          };
        };
      };
  };

  exe = lib.getExe wrapped.config.script;
  assets = runCommandLocal "wechat-desktop-assets" { } ''
    mkdir -p $out/share
    ln -s ${wechat}/share/icons $out/share/icons
  '';
in
buildEnv {
  inherit (wrapped.config.script) name passthru;
  meta = wrapped.config.script.meta // {
    mainProgram = "wechat";
  };
  paths = [
    wrapped.config.script
    assets
    (makeDesktopItem {
      name = "wechat";
      desktopName = "WeChat";
      exec = "${exe} %U";
      icon = "wechat";
      terminal = false;
      startupWMClass = "wechat";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/weixin" ];
      extraConfig.X-Flatpak = appId;
    })
  ];
}
