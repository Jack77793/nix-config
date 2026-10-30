{
  config,
  mySecrets,
  ...
}:

{
  age.secrets = {
    gemini = {
      file = "${mySecrets}/gemini.age";
      owner = config.custom.mainUser;
      mode = "0400";
    };
    deepseek = {
      file = "${mySecrets}/deepseek.age";
      owner = config.custom.mainUser;
      mode = "0400";
    };
  };
}
