{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.gui.gnome = {
    enable = lib.mkEnableOption "gnome";
  };
  config = lib.mkIf config.modules.gui.gnome.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    services.xserver.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      dconf-editor
      ffmpegthumbnailer
      gnome-chess
      gnome-tweaks
      gnomeExtensions.clipboard-history
      gnomeExtensions.dash-to-dock
      gnomeExtensions.user-themes
      gnomeExtensions.system-monitor
      gucharmap
      loupe
      papirus-icon-theme
      yaru-theme
    ];

    home-manager.users.${hostVariables.username} = {
      dconf.settings = {
        "org/gnome/shell" = {
          app-picker-layout = "[]";
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          disabled-extensions = [];
          enabled-extensions = [
            pkgs.gnomeExtensions.dash-to-dock.extensionUuid
            pkgs.gnomeExtensions.user-themes.extensionUuid
            pkgs.gnomeExtensions.system-monitor.extensionUuid
            pkgs.gnomeExtensions.clipboard-history.extensionUuid
          ];
        };
        "org/gnome/desktop/interface" = {
          clock-show-seconds = true;
          clock-show-weekday = true;
          show-battery-percentage = true;
          color-scheme = "prefer-dark";
          gtk-theme = "Yaru";
          cursor-theme = "Yaru";
          icon-theme = "Papirus-Dark";
        };
        "org/gnome/shell/extensions/user-theme" = {
          name = "Yaru-dark";
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "BOTTOM";
          dock-fixed = true;
          extend-height = true;
          dash-max-icon-size = 42;
          click-action = "minimize-or-previews";
          multi-monitor = true;
          scroll-action = "cycle-windows";
          disable-overview-on-startup = true;
          running-indicator-style = "DOTS";
        };
        "org/gnome/shell" = {
          favorite-apps = hostVariables.gnome.fav-icon;
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
          dynamic-workspaces = true;
          workspaces-only-on-primary = false;
        };
        "org/gtk/gtk4/settings/file-chooser" = {
          show-hidden = true;
        };
        "org/gnome/settings-daemon/plugins/power" = {
          idle-dim = false;
          sleep-inactive-battery-timeout = 900; # 15min
          sleep-inactive-battery-type = "nothing";
          sleep-inactive-ac-timeout = 900; # 15min
          sleep-inactive-ac-type = "nothing";
          power-button-action = "interactive";
        };
        "org/gnome/desktop/session" = {
          idle-delay = hostVariables.gnome.idle-delay;
        };
        "org/gnome/desktop/screensaver" = {
          lock-enabled = true;
          lock-delay = 0;
        };
        "org/gnome/desktop/notifications" = {
          show-in-lock-screen = false;
        };
        "org/gnome/desktop/peripherals/mouse" = {
          left-handed = hostVariables.gnome.left-handed;
        };

        # keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-terminal/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-filemanager/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-flameshot/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-terminal" = {
          name = "Open terminal";
          command = "kgx";
          binding = "<Super>r";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-filemanager" = {
          name = "Open file manager";
          command = "nautilus ./Downloads";
          binding = "<Super>e";
        };
      };
    };
  };
}
