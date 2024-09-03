{
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.software.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf config.modules.software.docker.enable {
    virtualisation.docker.enable = true;
    users.users.${hostVariables.username}.extraGroups = ["docker"];
  };
}
