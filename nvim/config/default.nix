{
  # Import all your configuration modules here
  imports = [./bufferline.nix];

  config = {
    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;

      autoindent = true;
    };

    colorschemes.gruvbox.enable = true;

    plugins = {
      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true;
          bashls.enable = true;
          nixd.enable = true;
        };
      };

      lsp-lines = {
        enable = true;
        currentLine = false;
      };

      fidget = {
        enable = true;
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      trouble = {
        enable = true;
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
        };
        extensions.fzf-native = {enable = true;};
      };

      nvim-autopairs.enable = true;
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            smart_indent_cap = true;
            char = " ";
          };
          scope = {
            enabled = true;
            char = "│";
          };
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<C-t>]]";
        };
      };
      #lightline.enable = true;
    };
  };
}
