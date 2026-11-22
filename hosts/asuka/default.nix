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
    development.agents.enable = true;
    security.agenix.enable = true;
    stateVersion = "26.05";
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

  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

  environment.persistence."/nix/persist" = {
    directories = [
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
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
