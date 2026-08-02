{
  mySecrets,
  ...
}:

{
  age.secrets = {
    "sing-box.json" = {
      file = "${mySecrets}/sing-box.json.age";
      path = "/etc/sing-box/config.json";
    };
  };
}
