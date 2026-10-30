{
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      duf
      file
      gawk
      gdu
      gnumake
    ]
    ++ lib.optional ((osConfig.custom.profile or null) != "sandbox") gnupg
    ++ [
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
