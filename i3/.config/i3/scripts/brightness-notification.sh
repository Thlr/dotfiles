#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

# Custom script, modified from the original

function get_brightness {
    xbacklight -get | cut -d '.' -f 1
}

function send_notification {
    DIR=`dirname "$0"`
    brightness=$(get_brightness)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($brightness/5)) | sed 's/[0-9]//g')
    icon_name="/usr/share/icons/Papirus/symbolic/status/display-brightness-symbolic.svg"
    if [ "$brightness" -lt "50" ]; then
        icon_name="/usr/share/icons/Papirus/symbolic/status/display-brightness-low-symbolic.svg"
    else
        if [ "$brightness" -lt "80" ]; then
            icon_name="/usr/share/icons/Papirus/symbolic/status/display-brightness-medium-symbolic.svg"
        else
            icon_name="/usr/share/icons/Papirus/symbolic/status/display-brightness-high-symbolic.svg"
        fi
    fi
    # Send the notification
    $DIR/notify-send.sh "$brightness""     ""$bar" -i "$icon_name" -t 2000 -h int:value:"$brightness" -h string:synchronous:"$bar" --replace=555
}

case $1 in
    up)
        # increase the backlight by 5%
        xbacklight -inc 5
        send_notification
        ;;
    down)
        # decrease the backlight by 5%
        xbacklight -dec 5
        send_notification
        ;;
esac
