# nixos-home

NixOS configuration for a QEMU VM running inside Proxmox on local hardware.

## Services

| Service | URL | Purpose |
|---------|-----|---------|
| aiostreams | https://aiostreams.ningen.xyz | Stremio addon aggregator — aggregates torrent/debrid streaming sources |
| jellyfin | https://jellyfin.ningen.xyz | Reverse proxy to Jellyfin running in a Proxmox LXC at 192.168.3.157:3000 |

Caddy handles TLS termination for both. Aiostreams runs as an OCI container on this VM; Jellyfin is external.

## External Dependencies

- **192.168.3.157** — Proxmox LXC container running Jellyfin. Static IP assigned in the router. If it becomes unreachable, check the LXC in Proxmox, not this VM.

## Deploying Changes

```bash
sudo nixos-rebuild switch --flake .#nixos-home
```

Run from the repo directory on the VM itself. The flake is at `/home/jacob/nixos-config`.

## Secrets Management

Secrets are encrypted with [sops-nix](https://github.com/Mic92/sops-nix) using the host's SSH ed25519 key (`/etc/ssh/ssh_host_ed25519_key`) as the age recipient.

Encrypted secrets live in `secrets/secrets.yaml`. To edit:

```bash
sops secrets/secrets.yaml
```

Current secrets:
- `aiostreams_env` — environment variables injected into the aiostreams container

## Container Updates

Docker images are pulled and containers restarted automatically every Sunday at 4:00 AM by the `docker-image-update` systemd service. To trigger manually:

```bash
sudo systemctl start docker-image-update.service
```

## Maintenance

- Nix store GC runs weekly, deleting generations older than 14 days
- Store is optimised (hard-linked) weekly and after each build
- `/tmp` is cleared on boot; `/var/tmp` entries older than 7 days are removed
- Zram swap is enabled (zstd, up to 50% of RAM)
