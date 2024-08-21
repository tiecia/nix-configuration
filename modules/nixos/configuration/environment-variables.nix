{
  config,
  lib,
  pkgs,
  ...
}: {
  environment = {
    sessionVariables = {
      EDITOR = "vi";
    };
  };
}
