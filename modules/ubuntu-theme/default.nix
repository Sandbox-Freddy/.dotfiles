{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.ubuntu-theme = {
    enable = lib.mkEnableOption "ubuntu-theme";
  };
  config = lib.mkIf config.modules.ubuntu-theme.enable {
    environment.systemPackages = with pkgs; [
      gnome3.dconf-editor
      gnome3.gnome-tweaks
      gnomeExtensions.dash-to-dock
      gnomeExtensions.user-themes
      gnomeExtensions.system-monitor
      yaru-theme
      papirus-icon-theme
      ffmpegthumbnailer
      loupe
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
          favorite-apps = hostVariables.ubuntu-theme.fav-icon;
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
          idle-delay = 300;
        };
        "org/gnome/desktop/screensaver" = {
          lock-enabled = true;
          lock-delay = 0;
        };
        "org/gnome/desktop/notifications" = {
          show-in-lock-screen = false;
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
