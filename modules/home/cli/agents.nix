{
  osConfig,
  lib,
  pkgs,
  myPkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs = {
    opencode = {
      enable = true;
      package = (
        pkgs.symlinkJoin {
          name = "opencode.wrapped";
          paths = [ pkgs.opencode ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/opencode \
            --set OPENCODE_DISABLE_LSP_DOWNLOAD "true"
          '';
        }
      );
      extraPackages = with pkgs; [
        bash-language-server
        clang-tools
        lua-language-server
        nixd
        pyright
        rust-analyzer
      ];
      settings = {
        autoupdate = false;
        formatter = true;
        lsp = true;
        provider = {
          deepseek.options.apiKey = "{file:${osConfig.age.secrets.opencode-ds.path}}";
          google.options.apiKey = "{file:${osConfig.age.secrets.gemini.path}}";
        };
        permission = {
          "*" = "ask";
          read = "allow";
          grep = "allow";
          glob = "allow";
          lsp = "allow";
          todowrite = "allow";
          webfetch = "allow";
          websearch = "allow";
          question = "allow";
          bash = {
            "ls *" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git status *" = "allow";
          };
        };
        share = "disabled";
      };
      tui.theme = "nord";
      skills = {
        humanizer = "${myPkgs.humanizer}/share/humanizer/SKILL.md";
        humanizer-zh = "${myPkgs.humanizer-zh}/share/humanizer-zh/SKILL.md";
      };
    };
  };
}
