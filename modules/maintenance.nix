{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------------------------
  # Nix store maintenance
  # ---------------------------------------------------------------------------

  # Automatic garbage collection — remove generations older than 14 days weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    persistent = true; # catch up if the machine was off during the scheduled run
  };

  # Automatically hard-link identical store paths after each build
  nix.settings.auto-optimise-store = true;

  # Also run a full store optimisation pass on a schedule
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # ---------------------------------------------------------------------------
  # Temporary file hygiene
  # ---------------------------------------------------------------------------

  # Clear /tmp on every boot
  boot.tmp.cleanOnBoot = true;

  # Periodically clean files in /var/tmp older than 7 days
  systemd.tmpfiles.rules = [
    "d /var/tmp 1777 root root 7d"
  ];

  # ---------------------------------------------------------------------------
  # Zram swap
  # ---------------------------------------------------------------------------

  zramSwap = {
    enable = true;

    # zstd gives the best compression-to-speed ratio for swap workloads
    algorithm = "zstd";

    # Allow zram to grow up to 50 % of physical RAM.
    # At 3:1 typical compression this effectively doubles usable memory.
    memoryPercent = 50;
  };

  # Kernel tunables optimised for a fast in-memory swap device
  boot.kernel.sysctl = {
    # High swappiness is correct for zram — evicting to compressed RAM is cheap
    "vm.swappiness" = 180;

    # Keep more inodes/dentries cached; less aggressive reclaim
    "vm.vfs_cache_pressure" = 50;

    # Prefer zram over any disk-based swap when both are present
    "vm.page-cluster" = 0;

    # Writeback thresholds — keep dirty pages flushed promptly
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };
}
