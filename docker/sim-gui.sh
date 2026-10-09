#!/bin/bash
# In-container helpers that drive the Connect IQ simulator's GUI (xdotool) so a listing screenshot is the real, native
# display (the same file the simulator's File > Save Screen Capture writes), with the clock and the activity data set.
# Source it from a scenario script run by docker/capture.sh. Needs the shots image (xdotool, faketime, ImageMagick).
#   sim_boot ["2026-10-04 10:09:00"]   (re)start the simulator, optionally on that clock (it then keeps running)
#   sim_load <jungle> <device> [monkeyc flags]   build the face in the project copy and run it; waits LOAD_WAIT s
#   sim_activity key=value ...   Simulation > Activity Monitoring > Set Activity Monitor Info, today's row:
#                                goal steps distance calories floors moderate vigorous floors_goal, and
#                                history=<steps,steps,...> (yesterday first; their goal stays 5000); then Apply
#   sim_activity_data_start      Simulation > Activity Data > Start + play: a simulated heart rate for Sensor.getInfo() (see below)
#   sim_24h                      Settings > Time Display > 24 Hour
#   sim_save <file.png>          File > Save Screen Capture: the display at native pixels
#   sim_always_on                Settings > Display Mode > Always-On: the face gets onEnterSleep (AMOLED always-on)
#   sim_burnin_24h <file.png>    File > View Screen Heat Map (Ctrl+N) > 24-Hour Simulation; saves the verdict box
# The GUI coordinates were read off the simulator on a 1280x1024 virtual screen; check one shot before trusting a new device.
export DISPLAY=${DISPLAY:-:1}

sim_click() { xdotool mousemove "$1" "$2" click 1; sleep "${3:-1}"; }

sim_boot() {
  pkill -f monkeydo 2>/dev/null; pkill -x simulator 2>/dev/null
  for _ in $(seq 20); do pgrep -x simulator >/dev/null || break; sleep 0.5; done; sleep 2
  if [ -n "${1:-}" ]; then faketime -f "@$1" simulator >/tmp/sim.log 2>&1 & else simulator >/tmp/sim.log 2>&1 & fi
  sleep 9
}

sim_load() {
  local jungle=$1 device=$2; shift 2
  monkeyc -d "$device" -f "$jungle" -o /tmp/app.prg -y /keys/developer_key -w "$@" >/tmp/build.log 2>&1 || { tail -5 /tmp/build.log; return 1; }
  pkill -f monkeydo 2>/dev/null
  (monkeydo /tmp/app.prg "$device" >/tmp/md.log 2>&1 &)
  sleep "${LOAD_WAIT:-25}"
}

# one cell of the Edit Activity Monitor Info table: double-click, type, Enter
sim_cell() { xdotool mousemove "$1" "$2" click --repeat 2 --delay 150 1; sleep 0.4; xdotool type --delay 25 "$3"; xdotool key Return; sleep 0.3; }

sim_open_activity() {
  sim_click 150 12 1; xdotool mousemove 150 80; sleep 0.3; xdotool mousemove 152 87; sleep 1.2; xdotool key Right; sleep 1.2
  sim_click 400 112 2
  # the dialog is centred on the simulator window, so its top (and height) depend on the device: read it, and place the
  # rows by their offsets from it (today's row +53, yesterday's +166, Apply 30 px above the bottom edge)
  local id; id=$(xdotool search --onlyvisible --name "Edit Activity Monitor Info" | head -1)
  eval "$(xdotool getwindowgeometry --shell "$id")"
  AM_Y=$Y; AM_H=$HEIGHT
}

sim_activity() {
  sim_open_activity
  local kv col i s
  for kv in "$@"; do
    case ${kv%%=*} in
      goal) col=277;; steps) col=397;; distance) col=517;; calories) col=637;; floors) col=757;;
      floors_goal) col=997;; moderate) col=1117;; vigorous) col=1237;;
      history)   # history=10000,10000,3000: steps for yesterday, the day before, ... (their goal stays 5000)
        i=0; for s in $(echo "${kv#*=}" | tr ',' ' '); do sim_cell 156 $((AM_Y + 166 + 25 * i)) "$s"; i=$((i + 1)); done; continue;;
      *) echo "sim_activity: unknown ${kv%%=*}" >&2; continue;;
    esac
    sim_cell "$col" $((AM_Y + 53)) "${kv#*=}"
  done
  sim_click 1213 $((AM_Y + AM_H - 30)) 1.5
  xdotool search --onlyvisible --name "Edit Activity Monitor Info" | xargs -r -n1 xdotool windowclose 2>/dev/null || true
}

# Simulation > Activity Data: the activity simulation ("Data Source: Data Simulation") feeds Sensor.getInfo() a heart rate that
# keeps changing. Click the dialog's Start (Data Field Timer Controls) and its play button, then close the dialog: the simulated
# activity keeps running. The dialog is 489x393 and centred on the simulator window (offsets read off it, FR965 and Instinct E).
sim_activity_data_start() {
  local X Y WIDTH HEIGHT id w; id=$(xdotool search --onlyvisible --name "CIQ Simulator" | head -1)
  eval "$(xdotool getwindowgeometry --shell "$id")"
  local dx=$((X + WIDTH / 2 - 245)) dy=$((Y + HEIGHT / 2 - 197))
  local try
  for try in 1 2 3; do   # the menu sometimes does not open on the first click: Escape and try again
    sim_click 150 12 1; sim_click 160 63 4
    w=$(for id in $(xdotool search --onlyvisible --name ""); do
          eval "$(xdotool getwindowgeometry --shell "$id" 2>/dev/null)"; [ "$WIDTH" = 489 ] && [ "$HEIGHT" = 393 ] && echo "$id"; done | head -1)
    [ -n "$w" ] && break; xdotool key Escape; sleep 1
  done
  [ -n "$w" ] || { echo "sim_activity_data_start: dialog not found" >&2; return 1; }
  sim_click $((dx + 60)) $((dy + 184)) 2     # Start
  sim_click $((dx + 30)) $((dy + 335)) 2     # play
  [ -n "${ACT_SHOT:-}" ] && xwd -id "$w" -display "$DISPLAY" | convert xwd:- "$ACT_SHOT"   # debug: the dialog as it is now
  xdotool windowclose "$w" 2>/dev/null; sleep 1
}

# Settings > Time Display > 24 Hour (the simulator starts on 12 Hour; a face with no AM/PM would read 20:00 as 08:00)
sim_24h() {
  sim_click 73 12 1; xdotool mousemove 80 28; sleep 0.3; xdotool mousemove 82 33; sleep 1; xdotool key Right; sleep 1.2
  sim_click 360 58 2
}

sim_save() {
  mkdir -p "$(dirname "$1")"; rm -f "$1"   # an existing file makes the dialog ask before replacing, and nothing is saved
  sim_click 20 12 1; sim_click 60 38 2
  xdotool type --delay 15 "$1"; sleep 0.5; xdotool key Return; sleep 2
  [ -s "$1" ] && echo "saved $1 $(identify -format '%wx%h' "$1")" || echo "NOT SAVED $1"
}

# Settings > Display Mode > Always-On (High Power / Always-On / Off). The face gets onEnterSleep and draws its always-on frame,
# once a minute after that (checked 2026-10-05 on Two Suns, fr965: dim text, drift between minutes). Display Mode is the
# second-to-last full row of the tall Settings menu on a 1024 px screen (y 958); the submenu opens on its first item.
sim_always_on() {
  sim_click 73 12 1.5; xdotool mousemove 120 958; sleep 1.5; xdotool key Right; sleep 0.8; xdotool key Down; sleep 0.4
  xdotool key Return; sleep 6
}

# File > View Screen Heat Map (Ctrl+N) and its 24-Hour Simulation, after sim_always_on. About 4 minutes; then a message box
# ("24-Hour simulation finished, no screen burn-in detected / Peak Luminance Usage: 1.09%" on Two Suns) is saved as a crop
# of the root window (xwd of that dialog reads black). The heat map window is found by its title ("Screen Burn-In Simulation";
# 2026-10-05: the old 454-px-wide match missed a Venu Sq 2's 320 x 501 window). It is as wide as the display; Start sits at
# 0.83 of its width and 98 px above its bottom ((377, 497) in an fr965's 454 x 595). The whole root is saved too, as
# <file>-root.png, since the verdict box can be wider than a small display's window.
sim_burnin_24h() {
  xdotool key ctrl+n; sleep 5
  local X Y WIDTH HEIGHT H
  H=$(xdotool search --onlyvisible --name "Screen Burn-In Simulation" | head -1)
  [ -n "$H" ] || { echo "sim_burnin_24h: heat map not found" >&2; return 1; }
  eval "$(xdotool getwindowgeometry --shell "$H")"
  sim_click $((X + WIDTH * 83 / 100)) $((Y + HEIGHT - 98)) 2; sleep 280
  import -window root "${1%.png}-root.png"
  import -window root -crop "${WIDTH}x${HEIGHT}+${X}+${Y}" "$1" && echo "saved $1"
}
