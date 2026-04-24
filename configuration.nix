{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/maintenance.nix
      ./modules/docker.nix
      ./modules/aiostreams.nix
      ./modules/mediaflow-proxy.nix
      ./modules/caddy.nix
      ./modules/security.nix
      ./modules/sops.nix
      ./modules/docker-update.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos-home";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Detroit";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.jacob = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = "auto";

  environment.systemPackages = with pkgs; [
    wget
    vim
    htop
    nload
    git
    claude-code
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # Do NOT change without reviewing migration impact
  system.stateVersion = "25.11";

}
