{
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.hardware.displaylink = {
    enable = lib.mkEnableOption "displaylink";
  };

  config = lib.mkIf config.modules.hardware.displaylink.enable (lib.mkMerge [
    {
      services.xserver.videoDrivers = lib.mkBefore ["displaylink" "modesetting"];
      systemd.services.dlm.wantedBy = ["multi-user.target"];
    }

    # GPUI has broken pointer coordinates on DisplayLink/Wayland, so Zed is
    # forced onto XWayland. Pointless on a host that does not install Zed.
    (lib.mkIf config.modules.software.zed.enable {
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
    })
  ]);
}
