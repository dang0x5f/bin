#!/bin/sh -x
#
# use "evtest /dev/input/eventX" to find device (where X is an integer 
# of available devs in dev/input) find the device by entering input, if 
# event codes return in output, it is the correct device.  # find the xinput 
# corresponding device name at the top of initial output should be displayed as:
#
#       Input device name: "USB Standard Keyboard" 
#
# since the rfid device is seen as a keyboard device.
# remove this name from the list using:
#
#       xinput --list -> xinput --disable $rfidscanner
#
# find the device name in the xinput --list output then disable it by id number
# disabling the device should persist after reboot and allows 
# the device input to be captured with evtest instead of going to stdout
#
# lastly, if the rfid device is reseated on the usb bus, its' eventX filename
# is subject to change and thus must be changed below in the device variable.
#
# In short, 
#          - find device with: evtest /dev/input/eventX
#          - find device name at beginning of evtest output once confirmed
#          - use xinput to list device, and disable device from interrupting stdout
#          - finally, find a way to run in background with root, here uses crontab.
#
# /etc/crontab entry: @reboot root:wheel /home/$USER/.local/bin/rfid.sh &
#
# tail -14  /var/log/Xorg.0.log | grep id | awk '{ print $NF }' | sed 's/)//'
# 
# libinput list-devices | grep "USB Standard" -A 1

dev_num=`xinput --list | grep "USB Standard" | awk '{ print $5 }' | cut -d= -f2`
xinput --disable $dev_num

# [Device]
device='/dev/input/event8'
# [Device Key Mappings]
#event_newline='*code 28 (KEY_ENTER), value 1*'
event_num0='*code 11 (KEY_0), value 1*'
event_num1='*code 2 (KEY_1), value 1*'
event_num2='*code 3 (KEY_2), value 1*'
event_num3='*code 4 (KEY_3), value 1*'
event_num4='*code 5 (KEY_4), value 1*'
event_num5='*code 6 (KEY_5), value 1*'
event_num6='*code 7 (KEY_6), value 1*'
event_num7='*code 8 (KEY_7), value 1*'
event_num8='*code 9 (KEY_8), value 1*'
event_num9='*code 10 (KEY_9), value 1*'

sudo evtest "$device" | while read line; do
    case $line in
        #($event_newline) echo -e "";;
        ($event_num0) code=${code}0;;
        ($event_num1) code=${code}1;;
        ($event_num2) code=${code}2;;
        ($event_num3) code=${code}3;;
        ($event_num4) code=${code}4;;
        ($event_num5) code=${code}5;;
        ($event_num6) code=${code}6;;
        ($event_num7) code=${code}7;;
        ($event_num8) code=${code}8;;
        ($event_num9) code=${code}9;;
    esac
    
    if [ `echo $code | wc -c` -eq 11 ]; then

        echo $code > /tmp/rfid.tmp
        cat /tmp/rfid.tmp

        case $code in
            #0007939453) su -l $USER -c 'env DISPLAY=:0 PATH="$PATH:$HOME/.local/bin" remote-backup.sh -l 2' ;;
            #0007939453) su -l $USER -c 'env DISPLAY=:0 /usr/local/bin/herbe "code scanned"' ;;
            #0007939453) cd $HOME/music/new-downloads/; herbe `pwd` ;;
            0007939453) cd $HOME/music/; yt-dlp -x --no-playlist --audio-format "mp3" --embed-thumbnail `xclip -o`; herbe "Downloaded" ;;
        esac
        code=""
    fi
done
