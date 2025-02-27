{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options = {nvim.enable = lib.mkEnableOption "Enable nvim";};

  config = let
    # custom-nvim = inputs.custom-nvim.packages.${pkgs.system}.default;
    inherit (pkgs) neovim;
  in
    lib.mkIf config.nvim.enable {
      home.packages = [
        # Dependencies as defined in kickstart.nvim
        pkgs.git
        pkgs.gnumake
        pkgs.unzip
        pkgs.libgccjit
        pkgs.ripgrep
        pkgs.xclip

        neovim
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          vi = "${neovim}/bin/neovim";
          v = "${neovim}/bin/neovim";
        };
        sessionVariables = {EDITOR = "${neovim}/bin/neovim";};
      };

      # home.packages = [
      #   custom-nvim
      #   pkgs.ripgrep # Needed for telescope
      # ];
      #
      # programs.bash = {
      #   enable = true;
      #   shellAliases = {
      #     vi = "${custom-nvim}/bin/nvim";
      #     v = "${custom-nvim}/bin/nvim";
      #   };
      #   sessionVariables = { EDITOR = "${custom-nvim}/bin/nvim"; };
      # };
    };
}
