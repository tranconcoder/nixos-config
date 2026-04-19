{ lib, ... }:

{
  hydenix.hm.hyprland = {
    enable = true;
    nvidia.enable = false;
    keybindings = {
      enable = true;
      overrideConfig = ''
        $wm=Window Management
        $d=[$wm]
        bindd = $mainMod, Q, $d close focused window, exec, $scrPath/dontkillsteam.sh
        bindd = Alt, F4, $d close focused window, exec, $scrPath/dontkillsteam.sh
        bindd = $mainMod, Delete, $d kill hyprland session, exec, hyde-shell logout
        bindd = $mainMod, W, $d Toggle floating, togglefloating
        bindd = $mainMod, G, $d toggle group, togglegroup
        bindd = Shift, F11, $d toggle fullscreen, fullscreen
        bindd = $mainMod, M, $d lock screen, exec, lockscreen.sh
        bindd = $mainMod Shift, F, $d toggle pin on focused window, exec, $scrPath/windowpin.sh
        bindd = Control Alt, Delete, $d logout menu, exec, $scrPath/logoutlaunch.sh
        bindd = Alt_R, Control_R, $d toggle waybar and reload config, exec, hyde-shell waybar --hide

        $d=[$wm|Group Navigation]
        bindd = $mainMod Control, H, $d change active group backwards   , changegroupactive, b
        bindd = $mainMod Control, L, $d change active group forwards  , changegroupactive, f

        $d=[$wm|Change focus]
        bindd = $mainMod, H, $d focus left, movefocus, l
        bindd = $mainMod, J, $d focus down, movefocus, d
        bindd = $mainMod, K, $d focus up, movefocus, u
        bindd = $mainMod, L, $d focus right, movefocus, r
        bindd = $mainMod, Left, $d focus left, movefocus, l
        bindd = $mainMod, Right, $d focus right , movefocus, r
        bindd = $mainMod, Up, $d focus up , movefocus, u
        bindd = $mainMod, Down , $d focus down, movefocus, d
        bindd = ALT, Tab,$d Cycle focus, cyclenext

        $d=[$wm|Resize Active Window]
        bindde = $mainMod Shift, Right, $d resize window right , resizeactive, 30 0
        bindde = $mainMod Shift, Left, $d resize window left, resizeactive, -30 0
        bindde = $mainMod Shift, Up, $d resize window up, resizeactive, 0 -30
        bindde = $mainMod Shift, Down, $d resize  window down, resizeactive, 0 30

        $d=[$wm|Move active window across workspace]
        $moveactivewindow=grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive
        bindde = $mainMod Shift Control, left, Move active window to the left, exec, $moveactivewindow -30 0 || hyprctl dispatch movewindow l
        bindde = $mainMod Shift Control, right, Move active window to the right, exec, $moveactivewindow 30 0 || hyprctl dispatch movewindow r
        bindde = $mainMod Shift Control, up, Move active window up, exec, $moveactivewindow  0 -30 || hyprctl dispatch movewindow u
        bindde = $mainMod Shift Control, down, Move active window down, exec, $moveactivewindow 0 30 || hyprctl dispatch movewindow d

        $d=[$wm|Move & Resize with mouse]
        binddm = $mainMod, mouse:272, $d hold to move window, movewindow
        binddm = $mainMod, mouse:273, $d hold to resize window, resizewindow
        binddm = $mainMod, Z, $d hold to move window , movewindow
        binddm = $mainMod, X, $d hold to resize window, resizewindow

        $d=[$wm]
        # bindd = $mainMod, J, $d toggle split, togglesplit

        $l=Launcher
        $d=[$l|Apps]
        bindd = $mainMod, T, $d terminal emulator , exec, $TERMINAL
        bindd = $mainMod Alt, T, $d dropdown terminal , exec, hyde-shell pypr toggle console
        bindd = $mainMod, E, $d file explorer , exec, $EXPLORER
        bindd = $mainMod, C, $d text editor , exec, $EDITOR
        bindd = $mainMod, B, $d web browser , exec, $BROWSER
        bindd = Control Shift, Escape, $d system monitor , exec, $scrPath/sysmonlaunch.sh

        $d=[$l|Rofi menus]
        $rofi-launch=$scrPath/rofilaunch.sh
        bindd = $mainMod, A, $d application finder , exec, pkill -x rofi || $rofi-launch d
        bindd = $mainMod, TAB, $d window switcher , exec, pkill -x rofi || $rofi-launch w
        bindd = $mainMod Shift, E, $d file finder , exec, pkill -x rofi || $rofi-launch f
        bindd = $mainMod, slash, $d keybindings hint, exec, pkill -x rofi || $scrPath/keybinds_hint.sh c
        bindd = $mainMod, comma, $d emoji  picker , exec, pkill -x rofi || $scrPath/emoji-picker.sh
        bindd = $mainMod, period, $d glyph picker , exec, pkill -x rofi || $scrPath/glyph-picker.sh
        bindd = $mainMod, V, $d clipboard ,  exec, pkill -x rofi || $scrPath/cliphist.sh -c
        bindd = $mainMod Shift, V, $d clipboard manager , exec, pkill -x rofi || $scrPath/cliphist.sh
        bindd = $mainMod Shift, A, $d select rofi launcher , exec, pkill -x rofi || $scrPath/rofiselect.sh

        $hc=Hardware Controls
        $d=[$hc|Audio]
        binddl  = , F10, $d toggle mute output , exec, $scrPath/volumecontrol.sh -o m
        binddl  = , XF86AudioMute,$d  toggle mute output, exec, $scrPath/volumecontrol.sh -o m
        binddel = , F11, $d decrease volume , exec, $scrPath/volumecontrol.sh -o d
        binddel = , F12, $d increase volume , exec, $scrPath/volumecontrol.sh -o i
        binddl  = , XF86AudioMicMute,$d un/mute microphone  , exec, $scrPath/volumecontrol.sh -i m
        binddel = , XF86AudioLowerVolume, $d decrease volume , exec, $scrPath/volumecontrol.sh -o d
        binddel = , XF86AudioRaiseVolume, $d increase volume , exec, $scrPath/volumecontrol.sh -o i

        $d=[$hc|Media]
        binddl  = , XF86AudioPlay,$d play media, exec, playerctl play-pause
        binddl  = , XF86AudioPause,$d pause media, exec, playerctl play-pause
        binddl  = , XF86AudioNext,$d next media  , exec, playerctl next
        binddl  = , XF86AudioPrev,$d  previous media , exec, playerctl previous

        $d=[$hc|Brightness]
        binddel = , XF86MonBrightnessUp, $d increase brightness , exec, $scrPath/brightnesscontrol.sh i
        binddel = , XF86MonBrightnessDown, $d decrease brightness , exec, $scrPath/brightnesscontrol.sh d

        $ut=Utilities
        $d=[$ut]
        binddl = $mainMod, K, $d toggle keyboard layout , exec, $scrPath/keyboardswitch.sh
        bindd = $mainMod Alt, G, $d game mode , exec, $scrPath/gamemode.sh
        bindd = $mainMod Shift, G, $d open game launcher , exec, $scrPath/gamelauncher.sh

        $d=[$ut|Screen Capture]
        bindd = $mainMod Shift, P, $d color picker, exec, hyprpicker -an
        bindd = $mainMod, P, $d snip screen , exec, $scrPath/screenshot.sh s
        bindd = $mainMod Control, P, $d freeze and snip screen, exec, $scrPath/screenshot.sh sf
        binddl = $mainMod Alt, P, $d print monitor , exec, $scrPath/screenshot.sh m
        binddl = , Print, $d print all monitors , exec, $scrPath/screenshot.sh p

        $rice=Theming and Wallpaper
        $d=[$rice]
        bindd = $mainMod Alt, Right, $d next global wallpaper , exec, $scrPath/wallpaper.sh -Gn
        bindd = $mainMod Alt, Left, $d previous global wallpaper , exec, $scrPath/wallpaper.sh -Gp
        bindd = $mainMod Shift, W, $d select a global wallpaper , exec, pkill -x rofi || $scrPath/wallpaper.sh -SG
        bindd = $mainMod Alt, Up, $d next waybar layout , exec, $scrPath/wbarconfgen.sh n
        bindd = $mainMod Alt, Down, $d previous waybar layout , exec, $scrPath/wbarconfgen.sh p
        bindd = $mainMod Shift, R, $d wallbash mode selector , exec, pkill -x rofi || $scrPath/wallbashtoggle.sh -m
        bindd = $mainMod Shift, T, $d select a theme, exec, pkill -x rofi || $scrPath/themeselect.sh
        bindd = $mainMod+Shift, Y, $d select animations, exec, pkill -x rofi || $scrPath/animations.sh --select
        bindd = $mainMod+Shift, U, $d select hyprlock layout, exec, pkill -x rofi || $scrPath/hyprlock.sh --select

        $ws=Workspaces
        $d=[$ws|Navigation]
        bindd = $mainMod, 1, $d navigate to workspace 1 , workspace, 1
        bindd = $mainMod, 2, $d navigate to workspace 2 , workspace, 2
        bindd = $mainMod, 3, $d navigate to workspace 3 , workspace, 3
        bindd = $mainMod, 4, $d navigate to workspace 4 , workspace, 4
        bindd = $mainMod, 5, $d navigate to workspace 5 , workspace, 5
        bindd = $mainMod, 6, $d navigate to workspace 6 , workspace, 6
        bindd = $mainMod, 7, $d navigate to workspace 7 , workspace, 7
        bindd = $mainMod, 8, $d navigate to workspace 8 , workspace, 8
        bindd = $mainMod, 9, $d navigate to workspace 9 , workspace, 9
        bindd = $mainMod, 0, $d navigate to workspace 10 , workspace, 10

        $d=[$ws|Navigation|Relative workspace]
        bindd = $mainMod Control, Right, $d change active workspace forwards  , workspace, r+1
        bindd = $mainMod Control, Left, $d change active workspace backwards , workspace, r-1

        $d=[$ws|Navigation]
        bindd = $mainMod Control, Down, $d navigate to the nearest empty workspace , workspace, empty

        $d=[$ws|Move window to workspace]
        bindd = $mainMod Shift, 1, $d move to workspace 1 , movetoworkspace, 1
        bindd = $mainMod Shift, 2, $d move to workspace 2 , movetoworkspace, 2
        bindd = $mainMod Shift, 3, $d move to workspace 3 , movetoworkspace, 3
        bindd = $mainMod Shift, 4, $d move to workspace 4 , movetoworkspace, 4
        bindd = $mainMod Shift, 5, $d move to workspace 5 , movetoworkspace, 5
        bindd = $mainMod Shift, 6, $d move to workspace 6 , movetoworkspace, 6
        bindd = $mainMod Shift, 7, $d move to workspace 7 , movetoworkspace, 7
        bindd = $mainMod Shift, 8, $d move to workspace 8 , movetoworkspace, 8
        bindd = $mainMod Shift, 9, $d move to workspace 9 , movetoworkspace, 9
        bindd = $mainMod Shift, 0, $d move to workspace 10 , movetoworkspace, 10

        $d=[$ws]
        bindd = $mainMod Control+Alt, Right, $d move window to next relative workspace , movetoworkspace, r+1
        bindd = $mainMod Control+Alt, Left, $d move window to previous relative workspace , movetoworkspace, r-1

        $d=[$ws|Navigation]
        bindd = $mainMod, mouse_down, $d next workspace, workspace, e+1
        bindd = $mainMod, mouse_up, $d previous workspace, workspace, e-1

        $d=[$ws|Navigation|Special workspace]
        bindd = $mainMod Shift, S, $d move to scratchpad  , movetoworkspace, special
        bindd = $mainMod Alt, S, $d move to scratchpad (silent) , movetoworkspacesilent, special
        bindd = $mainMod, S, $d toggle scratchpad ,  togglespecialworkspace

        $d=[$ws|Navigation|Move window silently]
        bindd = $mainMod Alt, 1, $d move to workspace 1  (silent), movetoworkspacesilent, 1
        bindd = $mainMod Alt, 2, $d move to workspace 2  (silent), movetoworkspacesilent, 2
        bindd = $mainMod Alt, 3, $d move to workspace 3  (silent), movetoworkspacesilent, 3
        bindd = $mainMod Alt, 4, $d move to workspace 4  (silent), movetoworkspacesilent, 4
        bindd = $mainMod Alt, 5, $d move to workspace 5  (silent), movetoworkspacesilent, 5
        bindd = $mainMod Alt, 6, $d move to workspace 6  (silent), movetoworkspacesilent, 6
        bindd = $mainMod Alt, 7, $d move to workspace 7  (silent), movetoworkspacesilent, 7
        bindd = $mainMod Alt, 8, $d move to workspace 8  (silent), movetoworkspacesilent, 8
        bindd = $mainMod Alt, 9, $d move to workspace 9  (silent), movetoworkspacesilent, 9
        bindd = $mainMod Alt, 0, $d move to workspace 10 (silent), movetoworkspacesilent, 10
      '';
    };
    extraConfig = ''
      decoration {
        blur {
          enabled = false
        }
        shadow {
          enabled = false
        }
      }

      animations {
        enabled = false
      }

      windowrule = opaque, class:.*

      exec-once = wlsunset -l 10.8 -L 106.7
    '';
  };
}
