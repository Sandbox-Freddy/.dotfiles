{
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.hardware.displaylink = {
    enable = lib.mkEnableOption "displaylink";
  };

  config = lib.mkIf config.modules.hardware.displaylink.enable {
    services.xserver.videoDrivers = ["displaylink" "modesetting" "amdgpu"];
    systemd.services.dlm.wantedBy = ["multi-user.target"];

    # Zed (GPUI) has broken pointer coordinates on DisplayLink/Wayland — force XWayland
    environment.shellAliases.zeditor = "env WAYLAND_DISPLAY= zeditor";

    home-manager.users.${hostVariables.username} = {
      xdg.desktopEntries."dev.zed.Zed" = {
        name = "Zed";
        exec = "env WAYLAND_DISPLAY= zeditor %F";
        icon = "zed";
        comment = "A high-performance, multiplayer code editor";
        categories = ["TextEditor" "Development" "IDE"];
        mimeType = [
          "text/plain"
          "inode/directory"
        ];
      };
    };
  };
}
