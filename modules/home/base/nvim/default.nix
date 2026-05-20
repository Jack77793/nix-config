{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = (
      with pkgs;
      [
        bash-language-server
        clang-tools
        cmake
        fd
        gcc
        gnumake
        lua-language-server
        nixd
        rust-analyzer
        rustfmt
        shellcheck
        stylua
        tree-sitter
      ]
    );
    initLua = builtins.readFile ./config/init.lua + builtins.readFile ./config/keybinds.lua;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nordic-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/nordic.lua;
      }
      {
        plugin = barbar-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/barbar.lua;
      }
      { plugin = nvim-web-devicons; } # required by barbar.nvim
      {
        plugin = better-escape-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/betterescape.lua;
      }
      # { plugin = codewindow-nvim; type = "lua"; config = builtins.readFile ./config/plugins/codewindow.lua; }
      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/conform.lua;
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/gitsigns.lua;
      }
      {
        plugin = hop-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/hop.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/ibl.lua;
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/lualine.lua;
      }
      {
        plugin = luasnip;
        type = "lua";
        config = builtins.readFile ./config/plugins/luasnip.lua;
      }
      { plugin = friendly-snippets; } # required by luasnip
      {
        plugin = neoscroll-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/neoscroll.lua;
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = builtins.readFile ./config/plugins/autopairs.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./config/plugins/cmp.lua;
      }
      { plugin = cmp-nvim-lsp; } # required by cmp
      { plugin = cmp-nvim-lua; } # required by cmp
      { plugin = cmp-buffer; } # required by cmp
      { plugin = cmp-path; } # required by cmp
      { plugin = cmp-cmdline; } # required by cmp
      { plugin = cmp_luasnip; } # required by cmp
      { plugin = lspkind-nvim; } # required by cmp
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = builtins.readFile ./config/plugins/colorizer.lua;
      }
      {
        plugin = nvim-lilypond-suite;
        type = "lua";
        config = builtins.readFile ./config/plugins/nvls.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./config/plugins/lsp.lua;
      }
      {
        plugin = nvim-surround;
        type = "lua";
        config = builtins.readFile ./config/plugins/surround.lua;
      }
      {
        plugin = (
          nvim-treesitter.withPlugins (
            p: with p; [
              bash
              c
              cpp
              css
              html
              ini
              json
              latex
              lua
              make
              markdown
              nix
              python
              rust
              toml
              vim
              xml
              yaml
            ]
          )
        );
        type = "lua";
        config = builtins.readFile ./config/plugins/treesitter.lua;
      }
      { plugin = plenary-nvim; } # required by telescope
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/telescope.lua;
      }
      { plugin = telescope-fzf-native-nvim; } # required by telescope
      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/toggleterm.lua;
      }
      {
        plugin = vim-illuminate;
        type = "lua";
        config = builtins.readFile ./config/plugins/illuminate.lua;
      }
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
