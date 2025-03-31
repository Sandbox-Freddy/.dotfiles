{
  username = "freddy";
  host = "work";
  system = "x86_64-linux";
  stateVersion = "24.11";
  printer = true;
  modules = {
    driver = {
      nvidia = false;
      amdgpu = true;
    };
    docker = true;
    display-link = true;
    discord = false;
    git = true;
    flatpak = false;
    idea-ultimate = true;
    webstorm = false;
    lutris = false;
    noisetorch = true;
    steam = false;
    gnome = true;
    kde = false;
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
    includes = [
      {
        path = "~/Dev/.gitconfig";
        condition = "gitdir:~/Dev/";
      }
    ];
  };
  gnome = {
    fav-icon = [
      "org.gnome.Console.desktop"
      "google-chrome.desktop"
      "firefox.desktop"
      "insomnia.desktop"
      "idea-ultimate.desktop"
      "code.desktop"
      "chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Default.desktop"
      "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
      "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
      "com.yubico.authenticator.desktop"
      "org.keepassxc.KeePassXC.desktop"
      "org.gnome.Nautilus.desktop"
      "org.gnome.TextEditor.desktop"
    ];
  };
}
