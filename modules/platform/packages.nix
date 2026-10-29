{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.hostDefaults.enable {
  environment.systemPackages = with pkgs; [
    btrfs-progs
    dosfstools
    e2fsprogs
    exfatprogs
    kexec-tools
    psmisc
    sbctl
    smartmontools
    wget
    xfsprogs
  ];
}
