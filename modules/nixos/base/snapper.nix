{ myVars, ... }:

{
  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ myVars.username ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;

      TIMELINE_LIMIT_HOURLY = 6;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 0;
      TIMELINE_LIMIT_MONTHLY = 4;
      TIMELINE_LIMIT_QUARTERLY = 2;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };
}
