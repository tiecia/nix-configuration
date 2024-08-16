# A lot of inspiration from https://github.com/tolgaerok/nixos-kde/blob/3c4b55f2b0345facc5bc5157750dfaecef9d4d6c/core/gpu/nvidia/nvidia-stable-opengl/default.nix
# https://nixos.wiki/wiki/Nvidia
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./vaapi.nix
  ];

  options.nvidia-graphics = {
    enable = lib.mkEnableOption "Enable Nvidia Graphics";
    prime = lib.mkOption {
      type = types.enum ["offload" "sync" "off"];
      default = "off";
      description = ''
        Select the Nvidia Optimus PRIME mode.
      '';
    };
    intelBusId = lib.mkOption {
      type = types.string;
      default = "";
      description = ''
        The PCI bus ID of the Intel GPU.
      '';
    };
    nvidiaBusId = lib.mkOption {
      type = types.string;
      default = "";
      description = ''
        The PCI bus ID of the Nvidia GPU.
      '';
    };
  };

  config = mkIf config.nvidia-graphics.enable {
    hardware.graphics = {
      enable = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
        nvidia-vaapi-driver
        cudaPackages.cuda_cccl
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        vulkan-validation-layers
      ];
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

    hardware = {
      enableAllFirmware = true;
      nvidia = {
        prime = mkIf (config.nvidia-graphics.prime != "off") {
          offload = mkIf (config.nvidia-graphics.prime == "offload") {
            enable = true;
            enableOffloadCmd = true;
          };

          reverseSync.enable = mkIf (config.nvidia-graphics.prime == "sync") true;
          allowExternalGpu = mkIf (config.nvidia-graphics.prime == "sync") false;

          intelBusId = config.nvidia-graphics.intelBusId;
          nvidiaBusId = config.nvidia-graphics.nvidiaBusId;
        };

        # Modesetting is required.
        modesetting.enable = true;

        nvidiaPersistenced = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.production;
        # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

        vaapi = {
          enable = true;
          firefox.enable = true;
        };
      };
    };

    boot.extraModprobeConfig =
      "options nvidia "
      + lib.concatStringsSep " " [
        # nvidia assume that by default your CPU does not support PAT,
        # but this is effectively never the case in 2023
        "NVreg_UsePageAttributeTable=1"
        # This may be a noop, but it's somewhat uncertain
        "NVreg_EnablePCIeGen3=1"
        # This is sometimes needed for ddc/ci support, see
        # https://www.ddcutil.com/nvidia/
        #
        # Current monitor does not support it, but this is useful for
        # the future
        "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
      ];

    # Set environment variables related to NVIDIA graphics
    environment.variables = {
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Apparently, without this nouveau may attempt to be used instead
      # (despite it being blacklisted)
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # Hardware cursors are currently broken on nvidia
      LIBVA_DRIVER_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      __GL_THREADED_OPTIMIZATION = "1";
      __GL_SHADER_CACHE = "1";
    };

    # Packages related to NVIDIA graphics
    environment.systemPackages = with pkgs; [
      clinfo
      gwe
      nvtopPackages.nvidia
      virtualglLib
      vulkan-loader
      vulkan-tools
    ];

    nix = {
      settings = {
        substituters = [
          "https://cuda-maintainers.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
    };
  };
}
