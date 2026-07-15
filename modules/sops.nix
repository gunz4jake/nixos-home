{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."caddy_env" = {
    owner = "caddy";
    mode = "0400";
    restartUnits = [ "caddy.service" ];
  };

}
