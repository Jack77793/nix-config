{ config, lib, ... }:

lib.mkIf config.custom.hostDefaults.enable {
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };

    snapper.configs.home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ config.custom.mainUser ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;

      TIMELINE_LIMIT_HOURLY = 6;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 0;
      TIMELINE_LIMIT_MONTHLY = 4;
      TIMELINE_LIMIT_QUARTERLY = 2;
      TIMELINE_LIMIT_YEARLY = 0;
    };

    smartd.enable = true;
  };

  environment.persistence."/nix/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/nixos"
      "/var/lib/AccountsService"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
