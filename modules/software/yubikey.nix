{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: {
  options.modules.software.yubikey = {
    enable = lib.mkEnableOption "yubikey";
  };

  config = lib.mkIf config.modules.software.yubikey.enable {
    # Smartcard daemon, required for the YubiKey to be picked up at all
    services.pcscd.enable = true;

    home-manager.users.${hostVariables.username} = {
      home.packages = with pkgs; [
        yubioath-flutter
      ];
    };
  };
}
