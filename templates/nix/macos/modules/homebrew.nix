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
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "obsidian"
      "arc"
      "raycast"
      "balenaetcher"
      "cursor"
      "hazeover"
      "istat-menus"
      "kaleidoscope"
      "keka"
      "kekaexternalhelper"
      "iina"
      "lunar"
      "zen-browser"
      "zoom"
      "zotero"
      "homerow"
      "1password"
      "karabiner-elements"
      "bartender"
      "mactex-no-gui"
      "rio"
      "ghostty"
    ];
    masApps = {
      "WeChat" = 836500024;
      "CotEditor" = 1024640650;
      "Tampermonkey" = 6738342400;
      "Pixelmator Pro" = 1289583905;
      "Infuse" = 1136220934;
      "Amphetamine" = 937984704;
      "PDF Viewer" = 1120099014;
      "Endel" = 1346247457;
      "Bear" = 1091189122;
      "Obsidian Web Clipper" = 6720708363;
      "AdGuard for Safari" = 1440147259;
      "1Password for Safari" = 1569813296;
      "Momentum" = 1564329434;
      "Raycast Companion" = 6738274497;
      "SnippetsLab" = 1006087419;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };
}
