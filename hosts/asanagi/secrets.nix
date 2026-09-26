{
  config,
  mySecrets,
  ...
}:

{
  age.secrets = {
    "sing-box.json" = {
      file = "${mySecrets}/sing-box.json.age";
      path = "/etc/sing-box/config.json";
    };
    "chromium" = {
      file = "${mySecrets}/chromium.age";
      mode = "0400";
      owner = config.custom.mainUser;
      group = "users";
    };
    "gemini" = {
      file = "${mySecrets}/gemini.age";
      mode = "0400";
      owner = config.custom.mainUser;
    };
    "gemini-sandbox" = {
      file = "${mySecrets}/gemini.age";
      path = "/run/agent-sandbox-secrets/gemini";
      mode = "0400";
      owner = config.custom.mainUser;
      symlink = false;
    };
    "config.dae" = {
      file = "${mySecrets}/config.dae.age";
      mode = "0400";
    };
    "deepseek" = {
      file = "${mySecrets}/deepseek.age";
      mode = "0400";
      owner = config.custom.mainUser;
    };
    "deepseek-sandbox" = {
      file = "${mySecrets}/deepseek.age";
      path = "/run/agent-sandbox-secrets/deepseek";
      mode = "0400";
      owner = config.custom.mainUser;
      symlink = false;
    };
  };
}
