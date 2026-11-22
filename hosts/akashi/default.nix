{
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../modules/platform/nix.nix
    ../../modules/terminal/tmux.nix
  ];

  networking.hostName = "Akashi";

  time.timeZone = "Asia/Shanghai";

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.nixos.openssh.authorizedKeys.keys = (import ../../modules/base/vars.nix).sshKeys;

  environment.systemPackages = with pkgs; [
    fastfetch-unwrapped
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings.publish = {
      publish-domain = true;
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };

  programs = {
    git = {
      enable = true;
      package = pkgs.gitMinimal;
    };
    htop.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
