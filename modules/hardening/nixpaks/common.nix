{
  config,
  lib,
  pkgs,
  sloth,
  ...
}:

let
  inherit (config.flatpak) appId;
  shortName = lib.last (lib.splitString "." appId);
  portalMethods = {
    fileChooser = [
      "FileChooser.OpenFile"
      "FileChooser.SaveFile"
      "FileChooser.SaveFiles"
    ];
    openUri = [
      "OpenURI.OpenURI"
      "OpenURI.OpenFile"
      "OpenURI.OpenDirectory"
    ];
    notifications = [
      "Notification.AddNotification"
      "Notification.RemoveNotification"
    ];
    screenCast = [
      "ScreenCast.CreateSession"
      "ScreenCast.SelectSources"
      "ScreenCast.Start"
      "ScreenCast.OpenPipeWireRemote"
    ];
    camera = [
      "Camera.AccessCamera"
      "Camera.OpenPipeWireRemote"
    ];
    inhibit = [
      "Inhibit.Inhibit"
      "Inhibit.CreateMonitor"
      "Inhibit.QueryEndResponse"
    ];
  };
in
{
  options = {
    network.enable = lib.mkEnableOption "isolated network access via pasta" // {
      default = true;
    };

    desktopIntegration = {
      notifications = lib.mkEnableOption "native desktop notifications";
      tray = lib.mkEnableOption "StatusNotifier tray integration";
      mpris = lib.mkEnableOption "MPRIS media controls for this application";
      accessibility = lib.mkEnableOption "the accessibility bus and AT-SPI socket";
    };

    portalGroups =
      lib.mapAttrs (name: _: lib.mkEnableOption "the ${name} desktop portal methods") portalMethods
      // {
        inputMethod = lib.mkEnableOption "IBus input method portal";
      };
  };

  config = lib.mkMerge [
    {
      gpu = {
        enable = lib.mkDefault true;
        provider = "nixos";
      };

      locale.enable = true;

      dbus = {
        policies = {
          "${appId}" = "own";
          "${appId}.*" = "own";
        };
        rules.call."org.freedesktop.portal.Desktop" = [
          "org.freedesktop.DBus.Properties.Get@/org/freedesktop/portal/desktop"
          "org.freedesktop.DBus.Properties.GetAll@/org/freedesktop/portal/desktop"
          "org.freedesktop.portal.Settings.Read@/org/freedesktop/portal/desktop"
          "org.freedesktop.portal.Settings.ReadAll@/org/freedesktop/portal/desktop"
          "org.freedesktop.portal.Request.Close@/org/freedesktop/portal/desktop/request/*"
          "org.freedesktop.portal.Session.Close@/org/freedesktop/portal/desktop/session/*"
        ]
        ++ lib.concatLists (
          lib.mapAttrsToList (
            name: methods:
            lib.optionals config.portalGroups.${name} (
              map (method: "org.freedesktop.portal.${method}@/org/freedesktop/portal/desktop") methods
            )
          ) portalMethods
        );
        rules.broadcast."org.freedesktop.portal.Desktop" = [
          "org.freedesktop.portal.Settings.SettingChanged@/org/freedesktop/portal/desktop"
          "@/org/freedesktop/portal/desktop/*"
        ];
      };

      bubblewrap = {
        network = lib.mkDefault false;
        newSession = true;
        dieWithParent = true;
        clearEnv = true;

        sockets = {
          wayland = true;
          x11 = lib.mkDefault false;
          pulse = lib.mkDefault true;
          pipewire = lib.mkDefault false;
        };

        bind.rw =
          with sloth;
          [
            [
              (mkdir (concat' runtimeDir "/nixpak-${appId}-tmp"))
              "/tmp"
            ]
            [
              (mkdir appCacheDir)
              xdgCacheHome
            ]
            [
              (mkdir appConfigDir)
              xdgConfigHome
            ]
            [
              (mkdir appDataDir)
              xdgDataHome
            ]
            [
              (mkdir (concat' appDir "/state"))
              xdgStateHome
            ]
          ]
          ++ lib.optional config.portalGroups.fileChooser (concat' runtimeDir "/doc");

        bind.ro =
          with sloth;
          [
            # Reuse the host's NixOS fontconfig so CJK glyph mappings match the host.
            [
              "/etc/static/fonts"
              "/etc/fonts"
            ]
            "/etc/localtime"
            "/etc/zoneinfo"
            "/sys/devices/platform"
            (concat' xdgConfigHome "/gtk-2.0")
            (concat' xdgConfigHome "/gtk-3.0")
            (concat' xdgConfigHome "/gtk-4.0")
            (concat' xdgConfigHome "/fontconfig")
          ]
          ++ lib.optionals config.gpu.enable [
            "/etc/egl"
            "/etc/static/egl"
          ];

        tmpfs = [
          "/dev/shm"
        ];

        env = {
          HOME = sloth.homeDir;
          USER = sloth.env "USER";
          XDG_RUNTIME_DIR = sloth.runtimeDir;
          XDG_CACHE_HOME = sloth.xdgCacheHome;
          XDG_CONFIG_HOME = sloth.xdgConfigHome;
          XDG_DATA_HOME = sloth.xdgDataHome;
          XDG_STATE_HOME = sloth.xdgStateHome;
          XDG_SESSION_TYPE = "wayland";
          XDG_CURRENT_DESKTOP = sloth.envOr "XDG_CURRENT_DESKTOP" "GNOME";
          WAYLAND_DISPLAY = sloth.envOr "WAYLAND_DISPLAY" "wayland-0";
          NIXOS_OZONE_WL = "1";
          GTK_USE_PORTAL = "1";
          GTK_A11Y = sloth.envOr "GTK_A11Y" "0";
          XDG_DATA_DIRS = lib.makeSearchPath "share" [
            pkgs.papirus-icon-theme
            pkgs.adwaita-icon-theme
            pkgs.shared-mime-info
          ];
          XCURSOR_PATH = "${pkgs.adwaita-icon-theme}/share/icons:${pkgs.adwaita-icon-theme}/share/pixmaps";
          FONTCONFIG_FILE = lib.mkDefault "/etc/fonts/fonts.conf";
          NIXOS_XDG_OPEN_USE_PORTAL = "1";
        }
        // lib.genAttrs [
          "LANG"
          "LANGUAGE"
          "LC_ALL"
          "LC_ADDRESS"
          "LC_COLLATE"
          "LC_CTYPE"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MESSAGES"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
          "XCURSOR_THEME"
          "XCURSOR_SIZE"
          "NO_AT_BRIDGE"
          "QT_QPA_PLATFORMTHEME"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION"
          "TZ"
          "TZDIR"
        ] (name: sloth.envOr name "");
      };
    }

    (lib.mkIf config.network.enable {
      etc.sslCertificates.enable = true;
      bubblewrap.network = true;
      pasta = {
        enable = lib.mkDefault true;
        mode = lib.mkDefault "isolate";
      };
    })

    (lib.mkIf config.portalGroups.inputMethod {
      dbus.policies."org.freedesktop.portal.IBus" = "talk";
    })

    (lib.mkIf config.desktopIntegration.notifications {
      dbus.policies."org.freedesktop.Notifications" = "talk";
    })

    (lib.mkIf config.desktopIntegration.tray {
      dbus.policies = {
        "org.freedesktop.DBus" = "talk";
        "org.kde.StatusNotifierWatcher" = "talk";
      }
      // builtins.listToAttrs (
        lib.concatMap (
          id:
          map (
            instance: lib.nameValuePair "org.kde.StatusNotifierItem-${toString id}-${toString instance}" "own"
          ) (lib.range 1 10)
        ) (lib.range 2 30)
      );
    })

    (lib.mkIf config.desktopIntegration.mpris {
      dbus.policies = builtins.listToAttrs (
        lib.concatMap
          (name: [
            (lib.nameValuePair "org.mpris.MediaPlayer2.${name}" "own")
            (lib.nameValuePair "org.mpris.MediaPlayer2.${name}.*" "own")
          ])
          (
            lib.unique [
              appId
              shortName
              (lib.toLower shortName)
            ]
          )
      );
    })

    (lib.mkIf config.desktopIntegration.accessibility {
      dbus.policies."org.a11y.Bus" = "see";
      dbus.rules.call."org.a11y.Bus" = [
        "org.a11y.Bus.GetAddress@/org/a11y/bus"
        "org.freedesktop.DBus.Properties.Get@/org/a11y/bus"
      ];
      bubblewrap.bind.ro = [ (sloth.concat' sloth.runtimeDir "/at-spi/bus") ];
    })
  ];
}
