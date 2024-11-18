{
  config,
  globalConfig,
  inputs,
  pkgs,
  pkgs-master,
  pkgs-stable,
  lib,
  ...
}:
with lib; {
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-master pkgs-stable globalConfig;};
    useGlobalPkgs = true;
    useUserPackages = true;
    # backupFileExtension = "backup";
  };
}
