{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.uv = {
    enable = true;
    settings = {
      exclude-newer = "3 days ago";
      python-downloads = "never";
      python-preference = "only-system";
      pip = {
        index-strategy = "unsafe-best-match";
        extra-index-url = [
          "https://mirrors.bfsu.edu.cn/pypi/web/simple"
          "https://mirror.nju.edu.cn/pypi/web/simple"
          "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
        ];
      };
    };
  };
}
