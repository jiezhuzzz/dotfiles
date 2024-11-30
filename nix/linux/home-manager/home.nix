{ config, pkgs, ... }:

{
  home.username = "cc";
  home.homeDirectory = "/home/cc";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    fastfetch
  ];
  programs.home-manager.enable = true;
}
