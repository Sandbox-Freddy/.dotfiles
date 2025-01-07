{
  pkgs,
  lib,
  config,
  nix-vscode-extensions,
  ...
}: {
  options.modules.software.discord = {
    enable = lib.mkEnableOption "discord";
  };

  config = lib.mkIf config.modules.software.discord.enable {
    environment.systemPackages = with pkgs; [
      discord-ptb
    ];
  };
}
