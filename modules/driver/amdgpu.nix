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
    boot.kernelParams = ["radeon.cik_support=0" "amdgpu.cik_support=1"];

    hardware.amdgpu.legacySupport.enable = true;

    services.xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
    };

    environment.systemPackages = with pkgs; [
      clinfo
      rocmPackages.rocm-runtime
      rocmPackages.rocm-smi
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        rocmPackages.clr.icd
        rocmPackages.rocm-runtime
        rocmPackages.rocm-device-libs
      ];
    };

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
