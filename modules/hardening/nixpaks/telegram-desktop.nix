{
  lib,
  pkgs,
  telegram-desktop,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  runCommandLocal,
}:

let
  appId = "org.telegram.desktop";

  wrapped = mkNixPak {
    config =
      { config, ... }:
      {
        imports = [
          ./common.nix
        ];

        app = {
          package = telegram-desktop;
          binPath = "bin/Telegram";
        };
        flatpak = {
          inherit appId;
        };

        dbus.policies = {
          "com.canonical.indicator.application" = "talk";
          "org.ayatana.indicator.application" = "talk";
          "org.sigxcpu.Feedback" = "talk";
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
          # Provide a stable synthetic app-scoped machine-id for D-Bus/WebKit consumers.
          bind.ro = [
            [
              (toString (
                pkgs.writeText "telegram-machine-id" "${
                  builtins.substring 0 32 (builtins.hashString "sha256" config.flatpak.appId)
                }\n"
              ))
              "/etc/machine-id"
            ]
          ];
          # nixpak exposes /.flatpak-info, so Telegram uses FLATPAK_ID as its Wayland app ID.
          env.FLATPAK_ID = appId;
        };
      };
  };

  exe = lib.getExe wrapped.config.script;
  assets = runCommandLocal "telegram-desktop-assets" { } ''
    mkdir -p $out/share
    ln -s ${telegram-desktop}/share/icons $out/share/icons
  '';
in
buildEnv {
  inherit (wrapped.config.script) name passthru;
  meta = wrapped.config.script.meta // {
    mainProgram = "Telegram";
  };
  paths = [
    wrapped.config.script
    assets
    (makeDesktopItem {
      name = appId;
      desktopName = "Telegram";
      comment = "New era of messaging";
      tryExec = exe;
      exec = "${exe} -- %u";
      icon = appId;
      terminal = false;
      startupNotify = true;
      startupWMClass = appId;
      type = "Application";
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
        "Qt"
      ];
      mimeTypes = [
        "x-scheme-handler/tg"
        "x-scheme-handler/tonsite"
      ];
      keywords = [
        "tg"
        "chat"
        "im"
        "messaging"
        "messenger"
        "sms"
        "tdesktop"
      ];
      actions = {
        quit = {
          name = "Quit Telegram";
          exec = "${exe} -quit";
          icon = "application-exit";
        };
      };
      extraConfig = {
        X-Flatpak = appId;
        SingleMainWindow = "true";
        X-GNOME-UsesNotifications = "true";
        X-GNOME-SingleWindow = "true";
      };
    })
  ];
}
