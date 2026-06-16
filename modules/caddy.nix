{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."aiostreams.ningen.xyz".extraConfig = ''
      reverse_proxy localhost:3000
    '';
virtualHosts."jellyfin.ningen.xyz".extraConfig = ''
      reverse_proxy 192.168.3.157:3000
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
