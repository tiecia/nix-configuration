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
        addFile = "<C-j>";
        toggleQuickMenu = "<C-k>";
        navNext = "<C-l>";
        navPrev = "<C-h>";
        navFile = {
          "1" = "<leader>h";
          "2" = "<leader>j";
          "3" = "<leader>k";
          "4" = "<leader>4";
        };
      };
    };
  };
}
