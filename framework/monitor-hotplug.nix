# Framework 13 AMD USB-C DisplayPort hotplug workaround.
#
# The USB-C ports negotiate DP Alt-Mode through a USB4/Thunderbolt retimer.
# udevadm monitor shows the amdgpu drm connector gets a "change" event right
# when the typec partner is first detected, but the retimer/link negotiation
# and USB hub enumeration keep going for several more seconds after that with
# no further drm event - so amdgpu probes the connector too early, sees it as
# unlinked, and never looks again. A suspend/resume "fixes" it only because
# resume forces a full re-enumeration of every connector. This retries a
# manual DRM re-probe for a few seconds after the typec partner appears,
# covering the window until the link actually comes up.
{ pkgs, ... }:

{
  systemd.services.redetect-external-display = {
    description = "Force DRM connector re-probe after USB-C DisplayPort hotplug";
    serviceConfig.Type = "oneshot";
    path = [ pkgs.gnugrep ];
    script = ''
      for i in 1 2 3 4 5; do
        sleep 2
        for f in /sys/class/drm/card*-DP-*/status /sys/class/drm/card*-HDMI-*/status; do
          [ -e "$f" ] || continue
          grep -q disconnected "$f" && echo detect > "$f"
        done
      done
    '';
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="typec", KERNEL=="port*-partner", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="redetect-external-display.service"
  '';
}
