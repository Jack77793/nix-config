{
  osConfig,
  pkgs,
  myPkgs,
  ...
}:

{
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
        };
        permission = {
          "*" = "ask";
          read = "allow";
          grep = "allow";
          glob = "allow";
          lsp = "allow";
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

    gemini-cli = {
      enable = true;
      package = (
        pkgs.symlinkJoin {
          name = "gemini-cli.wrapped";
          paths = [ pkgs.gemini-cli ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/gemini \
            --run 'export GEMINI_API_KEY=$(cat ${osConfig.age.secrets.gemini.path})' \
            --set GEMINI_SANDBOX "podman" \
            --set SANDBOX_SET_UID_GID "true" \
            --set SANDBOX_FLAGS "--userns=keep-id -v /nix/store:/nix/store:ro"
          '';
        }
      );
      settings = {
        security.auth.selectedType = "gemini-api-key";
        general = {
          enableAutoUpdate = false;
          vimMode = false;
          preferredEditor = "nvim";
        };
        ui = {
          showMemoryUsage = true;
          showModelInfoInChat = true;
          showCitations = true;
          footer = {
            hideContextPercentage = false;
            items = [
              "workspace"
              "git-branch"
              "sandbox"
              "model-name"
              "context-used"
              "quota"
              "memory-usage"
            ];
          };
          theme = "Default";
          inlineThinkingMode = "full";
        };
      };
    };
  };
}
