{ config, lib, pkgs, ... }:

{
  # Create a dedicated Docker network so the proxy can reach Redis by hostname
  systemd.services.create-mediaflow-network = {
    description = "Create mediaflow Docker network";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [ "docker-mediaflow-redis.service" "docker-mediaflow-proxy.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.docker}/bin/docker network inspect mediaflow >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create mediaflow
    '';
  };

  virtualisation.oci-containers.containers = {
    mediaflow-redis = {
      image = "redis:7-alpine";
      extraOptions = [ "--network=mediaflow" ];
      volumes = [ "/var/lib/mediaflow-redis:/data" ];
      autoStart = true;
    };

    mediaflow-proxy = {
      image = "mhdzumair/mediaflow-proxy:latest";
      ports = [ "8888:8888" ];
      environment = {
        FORWARDED_ALLOW_IPS = "127.0.0.1";
        REDIS_URL = "redis://mediaflow-redis:6379";
      };
      environmentFiles = [ config.sops.secrets."mediaflow_proxy_env".path ];
      extraOptions = [ "--network=mediaflow" ];
      dependsOn = [ "mediaflow-redis" ];
      autoStart = true;
    };
  };
}
