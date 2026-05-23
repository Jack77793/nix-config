{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      "--enable-features=UseOzonePlatform,MiddleClickAutoscroll,TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiIgnoreDriverChecks"
    ];
    nativeMessagingHosts = with pkgs; [
      (writeTextFile {
        name = "keepassxc-chromium-native-host";
        destination = "/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
        text = builtins.toJSON {
          name = "org.keepassxc.keepassxc_browser";
          description = "KeePassXC integration with native messaging support";
          path = "${keepassxc}/bin/keepassxc-proxy";
          type = "stdio";
          allowed_origins = [
            "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
          ];
        };
      })
    ];
  };

  home.packages = [
    (lib.hiPrio (
      pkgs.writeShellScriptBin "chromium" ''
        export LANG="zh_CN.UTF-8"
        export GOOGLE_API_KEY=$(sed -n "1p" ${osConfig.age.secrets.chromium.path} 2>/dev/null || echo "")
        export GOOGLE_DEFAULT_CLIENT_ID=$(sed -n "2p" ${osConfig.age.secrets.chromium.path} 2>/dev/null || echo "")
        export GOOGLE_DEFAULT_CLIENT_SECRET=$(sed -n "3p" ${osConfig.age.secrets.chromium.path} 2>/dev/null || echo "")

        exec ${config.programs.chromium.finalPackage}/bin/chromium "$@"
      ''
    ))
  ];

  services.psd = {
    enable = true;
    backupLimit = 3;
    browsers = [ "chromium" ];
  };
}
