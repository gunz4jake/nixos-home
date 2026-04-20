{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."aiostreams_env" = {
    owner = "root";
    mode = "0400";
    restartUnits = [ "docker-aiostreams.service" ];
  };

  sops.secrets."mediaflow_proxy_env" = {
    owner = "root";
    mode = "0400";
    restartUnits = [ "docker-mediaflow-proxy.service" ];
  };
}
