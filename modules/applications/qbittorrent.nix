{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.extras.qbittorrent.enable {
  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox;
    webuiPort = 28080;
    openFirewall = true;
    extraArgs = [ "--confirm-legal-notice" ];
    serverConfig = {
      Preferences = {
        General = {
          Locale = "zh_CN";
          StatusbarExternalIPDisplayed = true;
        };
        WebUI = {
          Username = "qbtuser";
          Password_PBKDF2 = "@ByteArray(bFkRa0NEsMVGq9hDH707rw==:w+fGAVOm5uJJyaqfXBXTzPTx3kaDpX/IvHy9T1SviH/AO8pZJU9ruk3oF0LSInuezqZFa0GNwUymVizIPZAMdQ==)";
          AuthSubnetWhitelistEnabled = true;
          AuthSubnetWhitelist = "100.64.0.0/10";
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        };
      };
      BitTorrent.Session = {
        AddExtensionToIncompleteFiles = true;
        AddTrackersFromURLEnabled = true;
        AdditionalTrackersURL = "https://cf.trackerslist.com/all.txt";
        PerformanceWarning = true;
        Preallocation = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [ vuetorrent ];

  environment.persistence."/nix/persist".directories = [
    config.services.qbittorrent.profileDir
  ];
}
