#!/bin/sh

CMD=$1
CMD_REPO=https://raw.githubusercontent.com/xordeio/xc/main/cmd/$CMD.sh

CMD_CODE=$(curl -s $CMD_REPO)

printf "Please confirm you want to run this code:\n\n$CMD_CODE\n\n(y/n)?"

old_stty_cfg=$(stty -g)
stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ; then
    echo Yes
    $CMD_CODE
else
    echo No
fi