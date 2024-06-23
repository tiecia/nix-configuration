{
  plugins = {
    comment = {
      enable = true;
      settings = {
        padding = true;
      };
    };

    markdown-preview.enable = true;

    harpoon = {
      enable = true;
      enableTelescope = true;
      keymaps = {
        addFile = "<S-j>";
        toggleQuickMenu = "<S-k>";
        navNext = "<S-l>";
        navPrev = "<S-h>";
        navFile = {
          "1" = "<C-h>";
          "2" = "<C-j>";
          "3" = "<C-k>";
          "4" = "<C-l>";
        };
      };
    };
  };
}
