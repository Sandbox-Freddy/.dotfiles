{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: {
  options.modules.hardware.yubikey = {
    enable = lib.mkEnableOption "yubikey";
  };

  config = lib.mkIf config.modules.hardware.yubikey.enable {
    services.pcscd.enable = true;

    home-manager.users.${hostVariables.username} = {
      home.packages = with pkgs; [
        yubioath-flutter
      ];
    };
  };
}
