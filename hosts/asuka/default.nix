{
  config,
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
    ../../modules/common/nix.nix
    ../../modules/nixos/development/agents/sandbox-guest.nix
  ];

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

  users.users.${config.custom.mainUser} = {
    uid = 1000;
    initialHashedPassword = myVars.initialHashedPassword;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = myVars.sshKeys;
  };
  security.sudo.wheelNeedsPassword = true;

  home-manager.users.${config.custom.mainUser}.custom.development.agentSandbox.secretPaths = {
    gemini = config.age.secrets.gemini.path;
    deepseek = config.age.secrets.deepseek.path;
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
