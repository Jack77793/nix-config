{ config, lib, ... }:

{
  imports = [ ../../../home/modules/terminal/shell ];

  programs.zsh = {
    dotDir = lib.mkForce config.home.homeDirectory;

    siteFunctions = {
      mkcd = lib.mkForce ''
        mkdir -p -- "$1" && cd -- "$1"
      '';
      try_until_success = lib.mkForce ''
        local i=1
        while true; do
            echo "Try $i at $(date)."
            "$@" && break
            (( i+=1 ))
            echo
        done
      '';
      run_continuously = lib.mkForce ''
        local i=1
        while true; do
            echo "Run $i at $(date)."
            "$@"
            (( i+=1 ))
            echo
        done
      '';
    };
  };
}
