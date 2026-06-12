{ nixfmt-rs, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      zip
      xz
      unzipNLS
      p7zip
      unrar
      zstd
      squashfsTools

      file
      which
      gnused
      gnutar
      gawk
      gnupg

      alsa-utils
      lm_sensors
      pciutils
      usbutils
      vulkan-tools

      fastfetch
      duf
      gdu
      gnumake
      net-tools
      rsync
      xxd
      whois

      (python3.withPackages (
        ps: with ps; [
          python-lsp-server
          python-lsp-jsonrpc
          python-lsp-black
          python-lsp-ruff
          pyls-isort
          pyls-flake8
          black
          isort
          flake8

          secretstorage
        ]
      ))
    ]
    ++ [ nixfmt-rs.packages.${pkgs.stdenv.hostPlatform.system}.default ];

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
