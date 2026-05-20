{
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
