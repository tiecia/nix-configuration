{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
in {
  options = {
    dotnet = {
      enable = lib.mkEnableOption "dotnet";
    };
  };

  config = let
    netcoredbg = pkgs.netcoredbg;

    dotnet-root = "share/dotnet";
    # This is needed to install workload in $HOME
    # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2
    userlocal = ''
       for i in $out/${dotnet-root}/sdk/*; do
         i=$(basename $i)
         length=$(printf "%s" "$i" | wc -c)
         substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
         i="$substring""00"
         mkdir -p $out/${dotnet-root}/metadata/workloads/''${i/-*}
         touch $out/${dotnet-root}/metadata/workloads/''${i/-*}/userlocal
      done
    '';
    # append userlocal sctipt to postInstall phase
    postInstallUserlocal = finalAttrs: previousAttrs: {
      postInstall = (previousAttrs.postInstall or '''') + userlocal;
    };
    # append userlocal sctipt to postBuild phase
    postBuildUserlocal = finalAttrs: previousAttrs: {
      postBuild = (previousAttrs.postBuild or '''') + userlocal;
    };

    # use this if you don't need multiple SDK versions
    dotnet-combined = pkgs.dotnetCorePackages.sdk_9_0.unwrapped.overrideAttrs postInstallUserlocal;
  in
    lib.mkIf config.dotnet.enable
    {
      home.packages = [
        pkgs.jetbrains.rider
        # pkgs.dotnet-sdk_8
        # pkgs.dotnet-sdk_9
        # pkgs.dotnetCorePackages.sdk_8_0_1xx
        # pkgs.dotnetCorePackages.sdk_9_0_1xx

        # (pkgs.dotnetCorePackages.combinePackages [
        #   pkgs.dotnetCorePackages.sdk_9_0
        #   pkgs.dotnetCorePackages.sdk_8_0
        # ])

        dotnet-combined

        pkgs.azure-cli
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          riderd = "(rider &) &> /dev/null";
        };

        profileExtra = ''
          echo 'init from dotnet'
        '';

        sessionVariables = {
          DOTNET_ROOT = "${dotnet-combined}/${dotnet-root}";
        };
      };

      home.sessionVariables = {
        DOTNET_ROOT = "${dotnet-combined}/${dotnet-root}";
      };
    };
}
