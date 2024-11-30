{ config, pkgs, ... }:
let
  username = "{{USER}}";
  homeDirectory = "{{HOME}}";
in {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    fastfetch
    zellij
    neovim
  ];
  programs.home-manager.enable = true;
}
