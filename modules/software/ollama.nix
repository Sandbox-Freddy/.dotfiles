{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: {
  options.modules.software.ollama = {
    enable = lib.mkEnableOption "ollama ";
  };

  config = lib.mkIf config.modules.software.ollama.enable {
    environment.systemPackages = with pkgs; [
      unstable.ollama
    ];

    services.ollama = {
      enable = true;
      acceleration = "cuda";
      loadModels = ["llama3.2:3b" "gpt-oss:20b"];
    };
    services.open-webui.enable = true;
  };
}
