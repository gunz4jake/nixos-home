{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."aiostreams.ningen.xyz".extraConfig = ''
      reverse_proxy localhost:3000
    '';
    virtualHosts."mediaflow.ningen.xyz".extraConfig = ''
      reverse_proxy localhost:8888
    '';
    virtualHosts."jellyfin.ningen.xyz".extraConfig = ''
      reverse_proxy 192.168.2.162:8096
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
