{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."aiostreams_env" = {
    owner = "root";
    mode = "0400";
    restartUnits = [ "docker-aiostreams.service" ];
  };

}
