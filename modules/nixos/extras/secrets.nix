{
  config,
  lib,
  agenix,
  myVars,
  mySecrets,
  pkgs,
  ...
}:

lib.mkIf config.custom.extras.agenix.enable {
  environment.systemPackages = [
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age = {
    identityPaths = [
      "/nix/persist/etc/ssh/ssh_host_ed25519_key"
    ];
    secrets = {
      "sing-box.json" = {
        file = "${mySecrets}/sing-box.json.age";
        path = "/etc/sing-box/config.json";
      };
      "chromium" = {
        file = "${mySecrets}/chromium.age";
        mode = "0400";
        owner = config.custom.mainUser;
        group = "users";
      };
      "gemini" = {
        file = "${mySecrets}/gemini.age";
        mode = "0400";
        owner = config.custom.mainUser;
      };
      "config.dae" = {
        file = "${mySecrets}/config.dae.age";
        mode = "0400";
      };
      "opencode-ds" = {
        file = "${mySecrets}/opencode-ds.age";
        mode = "0400";
        owner = config.custom.mainUser;
      };
    };
  };
}
