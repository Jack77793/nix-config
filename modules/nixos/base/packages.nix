{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btrfs-progs
    dosfstools
    e2fsprogs
    exfatprogs
    git
    kexec-tools
    psmisc
    sbctl
    smartmontools
    wget
    xfsprogs
  ];

  programs = {
    proxychains = {
      enable = true;
      package = pkgs.proxychains-ng;
      proxies = {
        sing-box = {
          enable = true;
          type = "socks5";
          host = "127.0.0.1";
          port = 2012;
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    zsh.enable = true;
  };

  environment.pathsToLink = [
    "/share/zsh"
  ];
}
