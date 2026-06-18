{
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  networking.hostName = "Akashi";

  time.timeZone = "Asia/Shanghai";

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.nixos.openssh.authorizedKeys.keys = (import ../../modules/vars.nix).sshKeys;

  nixpkgs.hostPlatform = "x86_64-linux";
}
