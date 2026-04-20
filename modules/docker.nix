{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  users.users.jacob.extraGroups = [ "docker" ];
}
