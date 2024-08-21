{
  config,
  inputs,
  pkgs,
  pkgs-master,
  lib,
  ...
}:
with lib; {
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-master;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}
