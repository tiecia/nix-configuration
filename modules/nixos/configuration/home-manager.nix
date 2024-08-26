{
  config,
  inputs,
  pkgs,
  pkgs-master,
  pkgs-stable,
  lib,
  ...
}:
with lib; {
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-master pkgs-stable;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}
