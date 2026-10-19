{ pkgs, ... }:

{
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
