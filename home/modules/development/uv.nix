{
  programs.uv = {
    enable = true;
    settings = {
      exclude-newer = "3 days ago";
      pip = {
        extra-index-url = [
          "https://mirrors.bfsu.edu.cn/pypi/web/simple"
          "https://mirror.nju.edu.cn/pypi/web/simple"
          "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
        ];
        index-strategy = "unsafe-best-match";
      };
      python-downloads = "never";
      python-preference = "only-system";
    };
  };
}
