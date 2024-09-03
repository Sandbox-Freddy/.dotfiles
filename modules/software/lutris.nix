{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.lutris = {
    enable = lib.mkEnableOption "lutris";
  };
  config = lib.mkIf config.modules.software.lutris.enable {
    environment.systemPackages = with pkgs; [
      lutris
      (lutris.override {
        extraLibraries = pkgs: [
          # List library dependencies here
        ];
      })
      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
      })
    ];
  };
}
