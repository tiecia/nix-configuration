{
  config,
  globalConfig,
  inputs,
  pkgs,
  pkgs-master,
  pkgs-stable,
  pkgs-dotnet,
  lib,
  ...
}:
with lib; {
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-master pkgs-stable pkgs-dotnet globalConfig;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}
