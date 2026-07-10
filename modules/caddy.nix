{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-hEHgAG0F0ozHRAPuxEqLyTATBrE+pajeXDiSNwniorg=";
    };
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';
    virtualHosts."aiostreams.ningen.xyz".extraConfig = ''
      reverse_proxy localhost:3000
    '';
    virtualHosts."jellyfin.ningen.xyz".extraConfig = ''
      reverse_proxy 192.168.3.157:3000
    '';
    virtualHosts."nzb.ningen.xyz".extraConfig = ''
      reverse_proxy 192.168.3.157:5076
    '';
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.secrets."caddy_env".path;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
