{
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      format = "openpgp";
      signByDefault = true;
    };
    settings = {
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
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
    };
  };

  programs.gitui.enable = true;
}
