{
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.software.displaylink = {
    enable = lib.mkEnableOption "displaylink";
  };

  config = lib.mkIf config.modules.software.displaylink.enable {
    services.xserver.videoDrivers = ["displaylink" "modesetting" "amdgpu"];
    systemd.services.dlm.wantedBy = ["multi-user.target"];

    # Zed (GPUI) has broken pointer coordinates on DisplayLink/Wayland — force XWayland
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

      programs.fish.shellAliases = {
        zeditor = "env WAYLAND_DISPLAY= zeditor";
      };
    };
  };
}
