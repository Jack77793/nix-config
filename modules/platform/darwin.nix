{ config, lib, ... }:

lib.mkIf config.custom.hostDefaults.enable {
  networking = {
    computerName = "${config.networking.hostName}";
    localHostName = "${config.networking.hostName}";
    applicationFirewall = {
      enableStealthMode = true;
      allowSigned = true;
    };
  };

  power.sleep = {
    computer = 8;
    display = 5;
  };

  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleMeasurementUnits = "Centimeters";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleTemperatureUnit = "Celsius";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSTextShowsControlCharacters = true;
      "com.apple.keyboard.fnState" = false;
      "com.apple.swipescrolldirection" = true;
      "com.apple.trackpad.enableSecondaryClick" = true;
    };
    controlcenter.BatteryShowPercentage = true;
    dock = {
      autohide = true;
      mineffect = "scale";
      minimize-to-application = true;
      mru-spaces = false;
      show-recents = false;
      wvous-tl-corner = 2;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      NewWindowTarget = "Home";
      QuitMenuItem = true;
      ShowPathbar = true;
      _FXSortFoldersFirst = true;
    };
    loginwindow = {
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };
    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1;
      ShowDayOfWeek = true;
      ShowSeconds = true;
    };
    screencapture.type = "png";
    trackpad = {
      ActuateDetents = true;
      FirstClickThreshold = 0;
      TrackpadRightClick = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    swapLeftCtrlAndFn = true;
  };
}
