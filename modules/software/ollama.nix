{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  ollama-latest = pkgs.ollama.overrideAttrs (oldAttrs: rec {
    version = "0.11.4";
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

    services.ollama = {
      enable = true;
      package = ollama-latest;
      acceleration = "cuda";
      loadModels = ["llama3.2:3b" "gpt-oss:20b"];
    };
    services.open-webui.enable = true;
  };
}
