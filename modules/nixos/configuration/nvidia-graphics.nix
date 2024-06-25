# https://nixos.wiki/wiki/Nvidia
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
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
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      # driSupport = true;
      driSupport32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

    boot.kernelParams = [
      # Recommended for by https://wiki.hyprland.org/Nvidia/ for nvidia-vaapi-driver
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # This parameter is causing suspend issues on laptop
    ];

    hardware.nvidia = {
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

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

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
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    };
  };
}
