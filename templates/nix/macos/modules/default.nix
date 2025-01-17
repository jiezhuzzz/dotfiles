{
  config,
  pkgs,
  user,
  inputs,
  ...
}: {
  users.users.${user.name}.home = user.home;
  nix.settings.trusted-users = [
    "root"
    "@admin"
    user.name
  ];
  security.pam.enableSudoTouchIdAuth = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user.name} = import ./home.nix;
  };

  # The platform the configuration will be used on.
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  imports = [
    (import ./homebrew.nix {inherit inputs user pkgs config;})
    ./system.nix
  ];
}
