{ config, pkgs, ... }:

{
  home-manager.users.${config.custom.mainUser}.imports = [
    {
      home.packages = with pkgs; [
        alsa-utils
        duf
        file
        gawk
        gdu
        gnumake
        gnupg
        gnused
        gnutar
        lm_sensors
        net-tools
        nixfmt
        p7zip
        pciutils
        rsync
        squashfsTools
        unrar
        unzipNLS
        usbutils
        vulkan-tools
        which
        whois
        xxd
        xz
        zip
        zstd
      ];
    }
  ];
}
