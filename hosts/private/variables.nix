{
  username = "freddy";
  host = "private";
  system = "x86_64-linux";
  stateVersion = "24.11";
  printer = true;
  modules = {
    driver = {
      nvidia = true;
      amdgpu = false;
    };
    docker = true;
    display-link = false;
    git = true;
    flatpak = false;
    jetbrains = false;
    lutris = true;
    steam = true;
    gnome = false;
    kde = true;
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
      "thunderbird.desktop"
      "code.desktop"
      "steam.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };
}
