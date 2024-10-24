{
  username = "freddy";
  host = "thinclient";
  system = "x86_64-linux";
  printer = false;
  modules = {
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    docker = false;
    display-link = false;
    git = true;
    flatpak = true;
    jetbrains = false;
    lutris = false;
    steam = false;
    gnome = true;
    vscode = true;
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "31123359+Sandbox-Freddy@users.noreply.github.com";
      name = "Sandbox-Freddy";
    };
    includes = [];
  };
  gnome = {
    fav-icon = [
      "org.gnome.Console.desktop"
      "bitwarden.desktop"
      "google-chrome.desktop"
      "firefox.desktop"
      "code.desktop"
      "com.valvesoftware.SteamLink.desktop"
      "vlc.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };
}
