{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        clangd.enable = true;
        cssls.enable = true;
        html.enable = true;
        pyright.enable = true;
        marksman.enable = true;
        dockerls.enable = true;
        csharp.enable = true;

        kotlin-language-server.enable = true;

        # nixd.enable = true;
        nil-ls = {
          enable = true;
          settings.nix.flake.autoEvalInputs = true;
        };

        prolog-ls.enable = true;

        rust-analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };

        # ruff-lsp.enable = true;
        # elixirls.enable = true;
        # gleam.enable = true;
        # gopls.enable = true;
      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
    };
    lsp-lines = {
      enable = true;
      currentLine = true;
    };
    rust-tools.enable = true;
  };
}
