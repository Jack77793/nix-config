{ myVars, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      format = "openpgp";
      key = "CAE07E085EB3F663";
      signByDefault = true;
    };
    settings = {
      user = {
        name = myVars.username;
        email = myVars.useremail;
      };
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      log.date = "iso";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      diff-so-fancy = true;
    };
  };

  programs.gh = {
    enable = true;
    hosts = {
      "github.com" = {
        user = myVars.username;
      };
    };
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
    };
  };

  programs.gitui.enable = true;
}
