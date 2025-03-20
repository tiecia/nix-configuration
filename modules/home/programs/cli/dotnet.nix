{
  inputs,
  pkgs,
  pkgs-dotnet,
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

    userlocal = ''
       for i in $out/sdk/*; do
         i=$(basename $i)
         length=$(printf "%s" "$i" | wc -c)
         substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
         i="$substring""00"
         mkdir -p $out/metadata/workloads/''${i/-*}
         touch $out/metadata/workloads/''${i/-*}/userlocal
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
    # dotnet-combined = dotnetCorePackages.sdk_9_0.overrideAttrs postInstallUserlocal)

    # or use this if you ought to have multiple SDK versions
    # this will create userlocal files in both $DOTNET_ROOT and dotnet bin realtive path
    dotnet-combined =
      (with pkgs-dotnet.dotnetCorePackages;
        combinePackages [
          (sdk_9_0.overrideAttrs postInstallUserlocal)
          (sdk_8_0.overrideAttrs postInstallUserlocal)
        ])
      .overrideAttrs
      postBuildUserlocal;
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
        '';

        sessionVariables = {
          DOTNET_ROOT = "${dotnet-combined}";
        };
      };

      home.sessionVariables = {
        DOTNET_ROOT = "${dotnet-combined}";
      };
    };
}
