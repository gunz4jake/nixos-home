{ config, lib, pkgs, ... }:

{
  systemd.services.docker-image-update = {
    description = "Pull latest Docker images and restart containers";
    after = [ "docker.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      # Pull latest images
      ${pkgs.docker}/bin/docker pull ghcr.io/viren070/aiostreams:latest
      ${pkgs.docker}/bin/docker pull mhdzumair/mediaflow-proxy:latest
      ${pkgs.docker}/bin/docker pull redis:7-alpine

      # Restart containers to pick up new images
      ${pkgs.systemd}/bin/systemctl restart docker-mediaflow-redis.service
      ${pkgs.systemd}/bin/systemctl restart docker-mediaflow-proxy.service
      ${pkgs.systemd}/bin/systemctl restart docker-aiostreams.service
    '';
  };

  systemd.timers.docker-image-update = {
    description = "Weekly Docker image update timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 04:00:00";
      Persistent = true;
    };
  };
}
