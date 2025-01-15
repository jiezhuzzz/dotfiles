{
  config,
  pkgs,
  ...
}: {
  environment = {
    variables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
    };
    systemPackages = with pkgs; [
      # tools
      neovim
      ripgrep
      zellij
      procs
      fd
      direnv
      fastfetch

      # dev tools
      git
      rustup
      cmake
      uv
      colima
      devenv
    ];
    shellAliases = {
      ll = "ls -l";
      g = "git";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];
  programs = {
    direnv = {
      enable = true; # enable nix-direnv for faster experience
      silent = true; # hide the message when direnv is enabled
    };
  };
  services = {
    sketchybar.enable = false;
  };
  system = {
    stateVersion = 5;
    defaults = {
      ".GlobalPreferences"."com.apple.mouse.scaling" = 1.5;
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Automatic";
        "com.apple.mouse.tapBehavior" = 1;
      };
      WindowManager.EnableStandardClickToShowDesktop = false;
      controlcenter = {
        AirDrop = false;
        BatteryShowPercentage = false;
        Bluetooth = false;
        Display = false;
        FocusModes = true;
        NowPlaying = false;
        Sound = false;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.1;
        orientation = "bottom";
        expose-group-apps = true;
        static-only = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0;
        ShowDayOfWeek = false;
      };
      spaces.spans-displays = false;
      trackpad.Clicking = true;
    };
  };
}
