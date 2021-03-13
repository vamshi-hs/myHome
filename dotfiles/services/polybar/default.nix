{ config, lib, pkgs, ... }:
{
  home-manager.users.vamshi.services.polybar = {
    enable = true;
 #monitor = "eDP-1" i3 #e0deda#CCFFFFFF 
    extraConfig = ''[bar/mainbar]
background = #FFFFFFFF
foreground = #000000
font-0 = SF Pro Text:style=Medium:pixelsize=13;2
font-1 = Font Awesome 5 Free Solid:style=Regular:size=15;2
font-2 = Font Awesome 5 Brands:style=Regular:size=17;2
height = 37
line-size = 2
modules-left = apple 
modules-center = xwindow
modules-right = battery datetime
padding = 3
module-margin = 1.5
border-bottom-size =  4
border-color = #0f0f0f



[module/xwindow]
;https://github.com/jaagr/polybar/wiki/Module:-xwindow
type = internal/xwindow

; Available tokens:
;   %title%
; Default: %title%
label = %title%
label-maxlen = 70

[module/apple]
type = custom/text
content = 

[module/battery]
type = internal/battery
battery = BAT0
adapter = ADP0
;   <animation-charging>
format-charging =  <label-charging>

; Available tags:
;   <label-discharging> (default)
;   <bar-capacity>
;   <ramp-capacity>
;   <animation-discharging>
format-discharging = <label-discharging>

; Available tags:
;   <label-full> (default)
;   <bar-capacity>
;   <ramp-capacity>
;format-full = <ramp-capacity> <label-full>

; Available tokens:
;   %percentage% (default)
;   %time%
;   %consumption% (shows current charge rate in watts)
label-charging = %percentage%%

; Available tokens:
;   %percentage% (default)
;   %time%
;   %consumption% (shows current discharge rate in watts)
label-discharging = %percentage%%

; Available tokens:
;   %percentage% (default)
;label-full = Fully Charged
label-full = 

ramp-capacity-0 = ""
ramp-capacity-1 = ""
ramp-capacity-2 = ""
ramp-capacity-3 = ""
ramp-capacity-4 = ""

[module/network]
type = internal/network
interface = wlp2s0
label-disconnected = " Not connected" 
label-connected = ""

[module/datetime]
type = internal/date
date = %a , %b %d  %H:%M %p


[module/color]
bg = #FFFFFFFF
fg = #FFFFFFFF
ac = #FF1565C0
fga = #FF454545
trans = #00000000
white = #FFFFFF
black = #000000

;; Material Colors

red = #e53935
pink = #d81b60
purple = #8e24aa
deep-purple = #5e35b1
indigo = #3949ab
blue = #5895DC
light-blue = #039be5
cyan = #00acc1
teal = #00897b
green = #43a047
light-green = #7cb342
lime = #c0ca33
yellow = #FEC006
amber = #ffb300
orange = #F57C00
deep-orange = #f4511e
brown = #6d4c41
gray = #757575
blue-gray = #546e7a


[bar/docky]
background = #ffffff
height = 67
line-size = 2
border-size =  14
border-color = #0f0f0f
font-0 = Font Awesome 5 Free Solid:style=Regular:size=15;2
font-1 = Font Awesome 5 Brands:style=Regular:size=17;2
fixed-center = true
radius-top = 20.0
radius-bottom = 20.0
border-bottom-size = 0
override-redirect = false
bottom = true
modules-center = term web files edit

[module/term]
type = custom/text

content = "%{T3}%{T-}"
content-foreground = #000000 
content-background = #FFFFFFFF
content-padding = 0

click-left  = konsole &

[module/web]
type = custom/text

content = "%{T3}%{T-}"
content-foreground = #F57C00
content-background = #FFFFFFFF 
content-padding = 0

click-left  = firefox &

[module/files]
type = custom/text

content = "%{T3}%{T-}"
content-foreground = #5895DC 
content-background = #FFFFFFFF
content-padding = 0

click-left  = pcmanfm &

[module/edit]
type = custom/text

content = "%{T3}%{T-}"
content-foreground = #757575
content-background = #FFFFFFFF
content-padding = 0

click-left  = emacs &
'';
    script = "polybar mainbar & ";
  # "bar/top" = {
  #   monitor = "\${env:MONITOR:eDP1}";
  #   width = "100%";
  #   height = "3%";
  #   radius = 0;
  #   modules-center = "date";
  # };

  # "module/date" = {
  #   type = "internal/date";
  #   internal = 5;
  #   date = "%d.%m.%y";
  #   time = "%H:%M";
  #   label = "%time%  %date%";
  # };
  };
}
