{ config, lib, pkgs, ... }:

{
  virtualisation.oci-containers.containers.aiostreams = {
    image = "ghcr.io/viren070/aiostreams:latest";
    ports = [ "3000:3000" ];
    environment = {
      BASE_URL = "https://aiostreams.ningen.xyz";
    };
    environmentFiles = [ config.sops.secrets."aiostreams_env".path ];
    volumes = [ "/var/lib/aiostreams:/app/data" ];
    autoStart = true;
  };
}
