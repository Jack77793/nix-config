{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      git
      wget
    ]
    ++ [
      android-tools
      dig
      exiftool
      (ffmpeg.override {
        withJxl = true;
        withUnfree = true;
      })
      imagemagick
      lilypond
      mediainfo
      nmap
      pnpm
      qpdf
      scrcpy
      shntool
      tokei
      vorbis-tools
    ]
    ++ [
      zulu
      zulu8
      zulu17
    ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    casks = [
      "ghostty"
      "google-chrome"
      "keepassxc"
      "localsend"
      "moonlight"
      "prismlauncher"
      "sfm"
      "squirrel-app"
      "telegram-desktop"
      "thunderbird"
      "utm"
    ];
  };
}
