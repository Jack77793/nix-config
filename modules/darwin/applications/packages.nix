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
      nodejs
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
    enableZshIntegration = true;
    onActivation.cleanup = "zap";
    casks = [
      "audacity"
      "caffeine"
      "calibre"
      "ghostty"
      "gimp"
      "google-chrome"
      "keepassxc"
      "localsend"
      "moonlight"
      "obs"
      "prismlauncher"
      "sfm"
      "squirrel-app"
      "telegram-desktop"
      "thunderbird"
      "utm"
    ];
  };
}
