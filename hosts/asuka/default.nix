{
  config,
  lib,
  impermanence,
  myVars,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    impermanence.nixosModules.impermanence
    ../../modules/base/users.nix
    ../../modules/base/home-manager.nix
    ../../modules/platform/nix.nix
    {
      options.custom.development.enable = lib.mkEnableOption "extended development tools";
    }
  ];

  custom = {
    mainUser = myVars.username;
    development.enable = true;
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
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  users = {
    mutableUsers = false;
    users.${config.custom.mainUser} = {
      isNormalUser = true;
      uid = 1000;
      group = "users";
      home = "/home/${config.custom.mainUser}";
      linger = true;
      initialHashedPassword = myVars.initialHashedPassword;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = myVars.sshKeys;
    };
  };
  security.sudo.wheelNeedsPassword = true;

  home-manager = {
    enableLegacyProfileManagement = false;
    users.${config.custom.mainUser} = {
      imports = [ ./agents.nix ];
      home.stateVersion = config.system.stateVersion;
    };
  };

  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

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
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };

  system.stateVersion = "26.05";
}
