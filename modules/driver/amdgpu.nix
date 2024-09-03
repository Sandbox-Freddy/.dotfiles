{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.driver.amdgpu = {
    enable = lib.mkEnableOption "amdgpu";
  };

  config = lib.mkIf config.modules.driver.amdgpu.enable {
    boot.initrd.kernelModules = ["amdgpu"];

    services.xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };
  };
}
