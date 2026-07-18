{
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    alsa-utils
    duf
    file
    gawk
    gdu
    gnupg
    gnumake
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

    (python3.withPackages (
      ps:
      with ps;
      (
        lib.optionals osConfig.custom.nvim.extended [
          black
          flake8
          isort
          python-lsp-server
          rope
        ]
        ++ lib.optionals osConfig.custom.desktop.enable [ secretstorage ]
      )
    ))
  ];

  programs = {
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
  };
}
