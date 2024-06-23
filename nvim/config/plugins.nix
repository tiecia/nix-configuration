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
        addFile = "<A-j>";
        toggleQuickMenu = "<A-k>";
        navNext = "<A-l>";
        navPrev = "<A-h>";
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
