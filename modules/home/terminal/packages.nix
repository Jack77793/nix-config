{ pkgs, ... }:

{
  home.packages = with pkgs; [
    duf
    file
    gawk
    gdu
    gnumake
    gnupg
    gnused
    gnutar
    nixfmt
    p7zip
    rsync
    squashfsTools
    unrar
    unzipNLS
    which
    whois
    xxd
    xz
    zip
    zstd
  ];
}
