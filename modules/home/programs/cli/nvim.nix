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
        pkgs.gcc
        pkgs.ripgrep
        pkgs.xclip
        pkgs.binutils

        neovim
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          vi = "${neovim}/bin/nvim";
          v = "${neovim}/bin/nvim";
        };
        sessionVariables = {EDITOR = "${neovim}/bin/nvim";};
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
