{
  config,
  agenix,
  mySecrets,
  ...
}:

{
  imports = [ agenix.nixosModules.default ];

  age = {
    identityPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
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
  };
}
