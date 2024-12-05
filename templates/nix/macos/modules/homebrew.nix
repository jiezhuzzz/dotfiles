{
  config,
  pkgs,
  user,
  inputs,
  ...
}: {
  nix-homebrew = {
    enable = true;
    user = user.name;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    casks = [
      "obsidian"
      "arc"
      "raycast"
      "nx-studio"
      "balenaetcher"
      "cursor"
      "hazeover"
      "istat-menus"
      "kaleidoscope"
      "keka"
      "lunar"
      "zen-browser"
      "zoom"
      "zotero"
      "homerow"
      "1password"
    ];
    masApps = {
      "WeChat" = 836500024;
      "CotEditor" = 1024640650;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };
}
