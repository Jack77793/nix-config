{ config, mySecrets, ... }:

{
  home-manager.users.${config.custom.mainUser}.age.secrets = {
    gemini.file = "${mySecrets}/gemini.age";
    deepseek.file = "${mySecrets}/deepseek.age";
  };
}
