{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options = {nvim.enable = lib.mkEnableOption "Enable nvim";};

  config = let
    inherit (pkgs) neovim;
  in
    lib.mkIf config.nvim.enable {
      import = [
        inputs.tiecia-neovim.homeManagerModules.default
      ];
      # home.packages = [
      #   # Dependencies as defined in kickstart.nvim
      #   pkgs.git
      #   pkgs.gnumake
      #   pkgs.unzip
      #   pkgs.gcc
      #   pkgs.ripgrep
      #   pkgs.xclip
      #   pkgs.binutils
      #
      #   neovim
      # ];
      #
      # programs.bash = {
      #   enable = true;
      #   shellAliases = {
      #     vi = "${neovim}/bin/nvim";
      #     v = "${neovim}/bin/nvim";
      #   };
      #   sessionVariables = {EDITOR = "${neovim}/bin/nvim";};
      # };
    };
}
