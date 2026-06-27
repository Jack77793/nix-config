{
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  networking.hostName = "Akashi";

  time.timeZone = "Asia/Shanghai";

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.nixos.openssh.authorizedKeys.keys = (import ../../modules/vars.nix).sshKeys;

  nix = {
    settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirror.nju.edu.cn/nix-channels/store"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    channel.enable = false;
  };

  environment.systemPackages = with pkgs; [
    fastfetch-unwrapped
  ];

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
    tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 0;
      escapeTime = 50;
      historyLimit = 16384;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind v split-window -h
        bind s split-window -v

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5
      '';
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
