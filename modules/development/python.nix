{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.custom.development.python.extraPackages = lib.mkOption {
    type = lib.types.functionTo (lib.types.listOf lib.types.package);
    default = _: [ ];
    description = "Additional packages in the shared Python environment.";
  };

  config.home.packages = [
    (pkgs.python3.withPackages config.custom.development.python.extraPackages)
  ];
}
