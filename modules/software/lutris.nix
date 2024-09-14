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
  environment.systemPackages = with pkgs;[
    lutris
  ];

    environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries =  pkgs: [
        # List library dependencies here
      ];
    })
  ];

    environment.systemPackages = with pkgs; [
    (lutris.override {
       extraPkgs = pkgs: [
         # List package dependencies here
       ];
    })
  ];

  };
}
