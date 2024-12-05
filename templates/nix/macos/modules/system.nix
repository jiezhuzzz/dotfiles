{
  config,
  pkgs,
  ...
}: {
  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      # tools
      neovim
      ripgrep
      bat
      zellij
      procs
      fd

      # dev tools
      rustup
      cmake
      python3
      uv

      # apps
      rio
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
  ];

  system = {
    stateVersion = 5;
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.5;
        orientation = "bottom";
      };
      finder = {
        AppleShowAllExtensions = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
      };
    };
  };
}
