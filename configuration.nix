# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  username = "freddy";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Displaylink
  services.xserver.videoDrivers = ["displaylink" "modesetting" "amdgpu" ];
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Frederik Nies";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install direnv
  programs.direnv.enable = true;

  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [pkgs.firefoxpwa];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnome3.dconf-editor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.system-monitor
    yaru-theme
    firefoxpwa
    jetbrains.idea-ultimate
    git
    postman
    keepassxc
    teams-for-linux
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # Flakes
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [username];
    };
    extraOptions = ''
      !include /home/${username}/.nix.conf
    '';
  };

  #Theming
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = {
    # basic home-manager config
    home.username = "freddy";
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;

    # custom config
    programs.git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store";
      };
      userName = "Frederik Nies";
      userEmail = "frederik.nies@btc-ag.com";
    };
    dconf.settings = {
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
        icon-theme = "Yaru";
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
        favorite-apps = [
          "org.gnome.Console.desktop"
          "firefox.desktop"
          "postman.desktop"
          "FFPWA-01J6RZF9V0ZHKTFE2CNKN3MP1B.desktop"
          "teams-for-linux.desktop"
          "idea-ultimate.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "org.gnome.Nautilus.desktop"
        ];
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

  system.stateVersion = "24.05"; # Did you read the comment?
}
