{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  {
    home-manager.users.${config.custom.mainUser}.imports = [
      {
        home.packages = [
          (pkgs.python3.withPackages (
            ps:
            with ps;
            (
              lib.optionals config.custom.nvim.extended [
                black
                flake8
                isort
                python-lsp-server
                rope
              ]
              ++ lib.optionals config.custom.desktop.enable [ secretstorage ]
            )
          ))
        ];
      }
    ];
  }

  (lib.mkIf config.custom.desktop.enable {
    home-manager.users.${config.custom.mainUser}.imports = [
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
    ];
  })
]
