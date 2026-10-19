{ config, lib, ... }:

let
  homeConfig = config.home-manager.users.${config.custom.mainUser};
in
{
  programs.zsh.enable = true;

  environment.pathsToLink = [
    "/share/zsh"
  ];

  home-manager.users.${config.custom.mainUser}.imports = [
    {
      home.shell.enableZshIntegration = true;

      programs.zsh = {
        enable = true;
        enableCompletion = true;

        autocd = true;

        history = {
          ignoreDups = true;
          ignoreSpace = true;
          save = 10000;
        };

        setOptions = lib.mkBefore [
          "NO_NOMATCH"
          "COMPLETE_ALIASES"
          "AUTO_CD"
          "INTERACTIVE_COMMENTS"
          "LIST_PACKED"
          "MAGIC_EQUAL_SUBST"
        ];

        shellAliases = {
          ":q" = "exit";
          open = "xdg-open";
          ls = "eza";
          ll = "eza -lb";
          la = "eza -lab";
          tree = "eza -Ta";
        };

        siteFunctions = {
          mkcd = ''
            mkdir --parents "$1" && cd "$1"
          '';
          try_until_success = ''
            local i=1
            while true; do
                echo "Try $i at $(date)."
                $* && break
                (( i+=1 ))
                echo
            done
          '';
          run_continuously = ''
            local i=1
            while true; do
                echo "Run $i at $(date)."
                $*
                (( i+=1 ))
                echo
            done
          '';
        };

        defaultKeymap = "emacs";
        initContent = builtins.readFile ./config.zsh;

        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        dotDir = "${homeConfig.xdg.configHome}/zsh";
      };
    }
  ];
}
