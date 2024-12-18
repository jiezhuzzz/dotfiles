{pkgs, ...}: {
  home.stateVersion = "24.11";
  # specify my home-manager configs
  home.packages = with pkgs; [
    ripgrep
    fd
    aerospace
    zellij
    oh-my-posh
    atuin
    sheldon
    zoxide
    yazi
  ];
}
