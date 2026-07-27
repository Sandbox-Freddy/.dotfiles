{
  pkgs,
  config,
  lib,
  ...
}: {
  options.modules.software.python = {
    enable = lib.mkEnableOption "python";
  };

  config = lib.mkIf config.modules.software.python.enable {
    environment.systemPackages = with pkgs; [
      python3
      python3Packages.pip
      python3Packages.virtualenv
    ];
  };
}
