{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  ollama-latest = pkgs.ollama.overrideAttrs (oldAttrs: rec {
    version = "0.12.3";
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v${version}";
      sha256 = "joIA/rH8j+SJH5EVMr6iqKLve6bkntPQM43KCN9JTZ8=";
    };
    vendorHash = "sha256-SlaDsu001TUW+t9WRp7LqxUSQSGDF1Lqu9M1bgILoX4=";
  });
in {
  options.modules.software.ollama = {
    enable = lib.mkEnableOption "ollama ";
  };

  config = lib.mkIf config.modules.software.ollama.enable {
    environment.systemPackages = [ollama-latest];

    services.ollama = lib.mkMerge [
      {
        enable = true;
        package = ollama-latest;
      }
      (lib.mkIf (hostVariables.modules.driver.nvidia == true) {
        acceleration = "cuda";
      })
      (lib.mkIf (hostVariables.modules.driver.amdgpu == true) {
        acceleration = "rocm";
        environmentVariables = {
          HCC_AMDGPU_TARGET = "gfx1103";
        };
        rocmOverrideGfx = "11.0.3";
      })
    ];
    services.open-webui.enable = false;
  };
}
