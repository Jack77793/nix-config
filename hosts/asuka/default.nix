{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  custom = {
    profile = "sandbox";
    development.enable = true;
    security.agenix.enable = true;
    stateVersion = "26.05";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "Asuka";
    networkmanager.enable = true;
  };

  services = {
    dbus.enable = true;
    qemuGuest.enable = true;
    openssh.enable = true;
  };

  users.users.${config.custom.mainUser} = {
    group = "users";
    shell = pkgs.bashInteractive;
    linger = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  security.sudo.wheelNeedsPassword = true;

  home-manager.enableLegacyProfileManagement = false;

  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/nixos"
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    users.${config.custom.mainUser}.directories = [
      ".codex"
      ".pi/agent"
      ".config/git"
      ".config/gh"
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}
