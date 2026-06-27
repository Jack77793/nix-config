{ osConfig, ... }:

{
  programs.ripgrep.enable = true;
  programs.ripgrep-all.enable = (osConfig.custom.profile == "desktop");
}
