{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.niri;
in {
  options.custom.niri = {
    enable = mkEnableOption "Enable niri home-manager configuration";
  };

  config = mkIf cfg.enable {
    # Niri configuration via config file
    home.file."${config.xdg.configHome}/niri/config.kdl".text = ''
      input {
        keyboard {
          xkb {
            layout "us"
          }
        }
        touchpad {
          tap 
          dwt
          natural-scroll
          accel-speed 0.2
        }
        mouse {
          accel-speed 0.2
        }
      }

      output "eDP-1" {
        mode "2880x1920@120.000"
        scale 2.0
        position x=3440 y=0
      }
      output "DP-2" {
        mode "3440x1440@160.000"
        position x=0 y=0
      }

      layout {
        gaps 10
        center-focused-column "never"
        preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
          width 2
          active-color "#89b4fa"
          inactive-color "#45475a"
        }
        border {
          width 2
          active-color "#89b4fa"
          inactive-color "#45475a"
        }
        struts {
          left 0
          right 0
          top 0
          bottom 0
        }
      }

      prefer-no-csd

      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"


      environment {
        QT_QPA_PLATFORM "wayland"
        DISPLAY null
      }


      spawn-at-startup "waybar"
      spawn-at-startup "mako"
      spawn-at-startup "wpaperd"

      window-rule {
        geometry-corner-radius 8.0
        clip-to-geometry true
      }

      binds {
        "Mod+Return" { spawn "alacritty"; }
        "Mod+d" { spawn "rofi" "-show" "drun"; }
        "Mod+Shift+e" { spawn "wlogout"; }

        "Mod+q" { close-window; }

        "Mod+Left" { focus-column-left; }
        "Mod+Down" { focus-window-down; }
        "Mod+Up" { focus-window-up; }
        "Mod+Right" { focus-column-right; }
        "Mod+h" { focus-column-left; }
        "Mod+j" { focus-window-down; }
        "Mod+k" { focus-window-up; }
        "Mod+l" { focus-column-right; }

        "Mod+Ctrl+Left" { move-column-left; }
        "Mod+Ctrl+Down" { move-window-down; }
        "Mod+Ctrl+Up" { move-window-up; }
        "Mod+Ctrl+Right" { move-column-right; }
        "Mod+Ctrl+h" { move-column-left; }
        "Mod+Ctrl+j" { move-window-down; }
        "Mod+Ctrl+k" { move-window-up; }
        "Mod+Ctrl+l" { move-column-right; }

        "Mod+Home" { focus-column-first; }
        "Mod+End" { focus-column-last; }
        "Mod+Ctrl+Home" { move-column-to-first; }
        "Mod+Ctrl+End" { move-column-to-last; }

        "Mod+Shift+Left" { focus-monitor-left; }
        "Mod+Shift+Down" { focus-monitor-down; }
        "Mod+Shift+Up" { focus-monitor-up; }
        "Mod+Shift+Right" { focus-monitor-right; }
        "Mod+Shift+h" { focus-monitor-left; }
        "Mod+Shift+j" { focus-monitor-down; }
        "Mod+Shift+k" { focus-monitor-up; }
        "Mod+Shift+l" { focus-monitor-right; }

        "Mod+Shift+Ctrl+Left" { move-column-to-monitor-left; }
        "Mod+Shift+Ctrl+Down" { move-column-to-monitor-down; }
        "Mod+Shift+Ctrl+Up" { move-column-to-monitor-up; }
        "Mod+Shift+Ctrl+Right" { move-column-to-monitor-right; }
        "Mod+Shift+Ctrl+h" { move-column-to-monitor-left; }
        "Mod+Shift+Ctrl+j" { move-column-to-monitor-down; }
        "Mod+Shift+Ctrl+k" { move-column-to-monitor-up; }
        "Mod+Shift+Ctrl+l" { move-column-to-monitor-right; }

        "Mod+Page_Down" { focus-workspace-down; }
        "Mod+Page_Up" { focus-workspace-up; }
        "Mod+u" { focus-workspace-down; }
        "Mod+i" { focus-workspace-up; }

        "Mod+Ctrl+Page_Down" { move-column-to-workspace-down; }
        "Mod+Ctrl+Page_Up" { move-column-to-workspace-up; }
        "Mod+Ctrl+u" { move-column-to-workspace-down; }
        "Mod+Ctrl+i" { move-column-to-workspace-up; }

        "Mod+Shift+Page_Down" { move-workspace-down; }
        "Mod+Shift+Page_Up" { move-workspace-up; }
        "Mod+Shift+u" { move-workspace-down; }
        "Mod+Shift+i" { move-workspace-up; }

        "Mod+1" { focus-workspace 1; }
        "Mod+2" { focus-workspace 2; }
        "Mod+3" { focus-workspace 3; }
        "Mod+4" { focus-workspace 4; }
        "Mod+5" { focus-workspace 5; }
        "Mod+6" { focus-workspace 6; }
        "Mod+7" { focus-workspace 7; }
        "Mod+8" { focus-workspace 8; }
        "Mod+9" { focus-workspace 9; }

        "Mod+Ctrl+1" { move-column-to-workspace 1; }
        "Mod+Ctrl+2" { move-column-to-workspace 2; }
        "Mod+Ctrl+3" { move-column-to-workspace 3; }
        "Mod+Ctrl+4" { move-column-to-workspace 4; }
        "Mod+Ctrl+5" { move-column-to-workspace 5; }
        "Mod+Ctrl+6" { move-column-to-workspace 6; }
        "Mod+Ctrl+7" { move-column-to-workspace 7; }
        "Mod+Ctrl+8" { move-column-to-workspace 8; }
        "Mod+Ctrl+9" { move-column-to-workspace 9; }

        "Mod+Comma" { consume-window-into-column; }
        "Mod+Period" { expel-window-from-column; }

        "Mod+BracketLeft" { consume-or-expel-window-left; }
        "Mod+BracketRight" { consume-or-expel-window-right; }

        "Mod+r" { switch-preset-column-width; }
        "Mod+f" { maximize-column; }
        "Mod+Shift+f" { fullscreen-window; }
        "Mod+c" { center-column; }

        "Mod+Minus" { set-column-width "-10%"; }
        "Mod+Equal" { set-column-width "+10%"; }

        "Mod+Shift+Minus" { set-window-height "-10%"; }
        "Mod+Shift+Equal" { set-window-height "+10%"; }

        "Print" { screenshot; }
        "Ctrl+Print" { screenshot-screen; }
        "Alt+Print" { screenshot-window; }

        "Mod+Shift+Ctrl+t" { toggle-debug-tint; }

        // Media keys
        "XF86AudioRaiseVolume" { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
        "XF86AudioLowerVolume" { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
        "XF86AudioMute" { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        "XF86AudioMicMute" { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
        "XF86MonBrightnessUp" { spawn "brightnessctl" "s" "10%+"; }
        "XF86MonBrightnessDown" { spawn "brightnessctl" "s" "10%-"; }
        "XF86AudioPlay" { spawn "playerctl" "play-pause"; }
        "XF86AudioPause" { spawn "playerctl" "play-pause"; }
        "XF86AudioNext" { spawn "playerctl" "next"; }
        "XF86AudioPrev" { spawn "playerctl" "previous"; }
      }

      debug {
        render-drm-device "/dev/dri/renderD128"
      }
    '';


    # Waybar configuration
    programs.waybar = {
      enable = true;
      settings = [{
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;
        
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ 
          "pulseaudio" 
          "bluetooth"
          "network" 
          "custom/idle-inhibit"
          "battery" 
          "tray" 
        ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "focused" = "";
            "default" = "";
          };
        };

        "niri/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M   %e %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) 󰖩";
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format = "{ifname} via {gwaddr} 󰈀";
          format-linked = "{ifname} (No IP) 󰈀";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "󰝟 {icon} {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "󰂑";
            headset = "󰂑";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        "custom/idle-inhibit" = {
          format = "{icon}";
          format-icons = {
            "activated" = "󰛊";
            "deactivated" = "󰾫";
          };
          exec = "${pkgs.writeShellScript "waybar-idle-inhibit" ''
            #!/bin/bash
            while true; do
              if [ -f /tmp/idle-inhibit-active ]; then
                echo '{"text": "󰛊", "tooltip": "Idle inhibition active (media playing)", "class": "activated"}'
              else
                echo '{"text": "󰾫", "tooltip": "Idle inhibition inactive", "class": "deactivated"}'
              fi
              sleep 3
            done
          ''}";
          return-type = "json";
          interval = 5;
          tooltip = true;
        };

        tray = {
          spacing = 10;
        };
      }];
      
      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 13px;
            min-height: 0;
        }

        window#waybar {
            background-color: rgba(30, 30, 46, 0.9);
            color: #cdd6f4;
            transition-property: background-color;
            transition-duration: 0.5s;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces {
            background-color: transparent;
        }

        #workspaces button {
            background-color: transparent;
            color: #6c7086;
            border-radius: 8px;
            padding: 0 8px;
            margin: 4px 2px;
            transition: all 0.3s ease;
        }

        #workspaces button.focused {
            background-color: #7c3aed;
            color: #1e1e2e;
        }

        #workspaces button:hover {
            background-color: #585b70;
            color: #cdd6f4;
        }

        #window {
            background-color: rgba(108, 112, 134, 0.2);
            border-radius: 8px;
            padding: 0 12px;
            margin: 4px;
            color: #cdd6f4;
        }

        #clock,
        #battery,
        #network,
        #pulseaudio,
        #bluetooth,
        #custom-idle-inhibit,
        #tray {
            background-color: rgba(108, 112, 134, 0.2);
            border-radius: 8px;
            padding: 0 12px;
            margin: 4px 2px;
            color: #cdd6f4;
        }

        #clock {
            color: #fab387;
        }

        #battery.charging, #battery.plugged {
            color: #a6e3a1;
        }

        #battery.critical:not(.charging) {
            background-color: #f38ba8;
            color: #1e1e2e;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #network.disconnected {
            color: #f38ba8;
        }

        #pulseaudio.muted {
            color: #f38ba8;
        }

        #custom-idle-inhibit.activated {
            color: #a6e3a1;
        }

        #custom-idle-inhibit.deactivated {
            color: #6c7086;
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #000000;
            }
        }
      '';
    };

    # Rofi configuration
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        display-drun = "Applications";
        display-window = "Windows";
        drun-display-format = "{name}";
        font = "JetBrainsMono Nerd Font 11";
        modi = "window,run,drun";
        show-icons = true;
        icon-theme = "Papirus";
      };
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg = mkLiteral "#1e1e2e";
          bg-alt = mkLiteral "#313244";
          fg = mkLiteral "#cdd6f4";
          fg-alt = mkLiteral "#6c7086";
          
          background-color = mkLiteral "@bg";
          
          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "window" = {
          width = mkLiteral "30%";
          border = 1;
          border-color = mkLiteral "#7c3aed";
          border-radius = mkLiteral "8px";
        };

        "element" = {
          padding = mkLiteral "8 12";
          text-color = mkLiteral "@fg-alt";
        };

        "element selected" = {
          text-color = mkLiteral "@fg";
          background-color = mkLiteral "@bg-alt";
        };

        "element-text" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };

        "element-icon" = {
          size = 14;
          padding = mkLiteral "0 8 0 0";
          background-color = mkLiteral "inherit";
        };

        "entry" = {
          background-color = mkLiteral "@bg-alt";
          padding = 12;
          text-color = mkLiteral "@fg";
          border = mkLiteral "0 0 1px 0";
          border-color = mkLiteral "@fg-alt";
          border-radius = 0;
        };

        "inputbar" = {
          children = map mkLiteral [ "prompt" "entry" ];
        };

        "listview" = {
          background-color = mkLiteral "@bg";
          columns = 1;
          lines = 8;
        };

        "mainbox" = {
          background-color = mkLiteral "@bg";
          children = map mkLiteral [ "inputbar" "listview" ];
        };

        "prompt" = {
          background-color = mkLiteral "@bg-alt";
          enabled = true;
          padding = mkLiteral "12 0 0 12";
          text-color = mkLiteral "@fg";
        };
      };
    };

    # Swayidle for power management with media detection
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
        { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
      ];
      timeouts = [
        { 
          timeout = 300; 
          command = "${pkgs.swaylock-effects}/bin/swaylock -f";
          resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
        { 
          timeout = 600; 
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
        { 
          timeout = 1200; 
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };

    # Swaylock configuration
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        color = "1e1e2e";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        show-failed-attempts = true;
        image = "~/.config/wallpaper.jpg";
        effect-blur = "9x5";
        effect-vignette = "0.5:0.5";
        ring-color = "7c3aed";
        key-hl-color = "a6e3a1";
        line-color = "00000000";
        inside-color = "00000088";
        ring-ver-color = "89b4fa";
        inside-ver-color = "00000088";
        ring-wrong-color = "f38ba8";
        inside-wrong-color = "00000088";
      };
    };

    # Mako notification daemon
    services.mako = {
      enable = true;
      settings = {
        background-color = "#1e1e2e";
        border-color = "#7c3aed";
        border-radius = 8;
        border-size = 1;
        text-color = "#cdd6f4";
        font = "JetBrainsMono Nerd Font 11";
        width = 300;
        height = 100;
        padding = "12";
        margin = "8";
        default-timeout = 5000;
        layer = "overlay";
      };
    };

    # Wallpaper service
    systemd.user.services.wallpaper = {
      Unit = {
        Description = "Set wallpaper";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i ~/.config/wallpaper.jpg -m fill";
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Auto-start services
    systemd.user.services.blueman-applet = {
      Unit = {
        Description = "Bluetooth manager applet";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.blueman}/bin/blueman-applet";
        Restart = "on-failure";
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.network-manager-applet = {
      Unit = {
        Description = "Network manager applet";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        Restart = "on-failure";
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Media-aware idle inhibition service
    systemd.user.services.idle-inhibit = {
      Unit = {
        Description = "Idle inhibition for media playback";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.writeShellScript "idle-inhibit" ''
          #!/bin/bash
          
          # Function to check if audio is playing
          is_audio_playing() {
            # Check if any audio streams are running and not just monitoring
            ${pkgs.wireplumber}/bin/wpctl status | grep -A 20 "Audio" | grep -q "RUNNING"
          }
          
          # Function to check if video is playing via playerctl
          is_video_playing() {
            # Check if any media player is playing
            ${pkgs.playerctl}/bin/playerctl status 2>/dev/null | grep -q "Playing"
          }
          
          # Function to send idle inhibition signal to swayidle
          send_inhibit_signal() {
            ${pkgs.procps}/bin/pkill -STOP swayidle 2>/dev/null || true
          }
          
          # Function to resume swayidle
          resume_swayidle() {
            ${pkgs.procps}/bin/pkill -CONT swayidle 2>/dev/null || true
          }
          
          inhibit_active=false
          
          while true; do
            should_inhibit=false
            
            # Check various conditions for inhibiting idle
            if is_audio_playing || is_video_playing; then
              should_inhibit=true
            fi
            
            # Start inhibiting if we should and aren't already
            if [ "$should_inhibit" = true ] && [ "$inhibit_active" = false ]; then
              echo "$(date): Starting idle inhibition (media detected)"
              send_inhibit_signal
              inhibit_active=true
              # Create a marker file for waybar
              touch /tmp/idle-inhibit-active
            fi
            
            # Stop inhibiting if we shouldn't and are currently
            if [ "$should_inhibit" = false ] && [ "$inhibit_active" = true ]; then
              echo "$(date): Stopping idle inhibition (no media detected)"
              resume_swayidle
              inhibit_active=false
              # Remove marker file
              rm -f /tmp/idle-inhibit-active
            fi
            
            sleep 5
          done
        ''}";
        Restart = "always";
        RestartSec = 5;
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Download and set wallpaper
    home.activation.setupWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ~/.config
      if [ ! -f ~/.config/wallpaper.jpg ]; then
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -L "https://4kwallpapers.com/images/walls/thumbs_3t/15623.jpg" -o ~/.config/wallpaper.jpg
      fi
    '';
  };
}
