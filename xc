#!/bin/sh

CMD=$1
SELF=$0

### show help if no arguments
if [ $# -eq 0 ]; then
  printf "Error: No arguments supplied\n\n" >&2
  cat << EOF
Usage:
  xc <short-code>|<code>

  Arguments:

    short-code      
      numeric command short-code
      example: xc 1         
    
    code
      alphanumeric command code
      example: xc update

  Predefined short-codes:
    1 = update
EOF
  exit 1
fi

### check if CMD is numeric code:
if [ -n "$CMD" ] && [ "$CMD" -eq "$CMD" ] 2>/dev/null; then
    if [ "$CMD" -eq "1" ]; then
        CMD=update
    else
        printf "Resolving numeric shortcut..."
        SHORTCUTS=$(curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/xordeio/xc/main/shortcuts.txt)
        CMD=$(echo "$SHORTCUTS" | grep -Po "(?<=^$1=)\w*$")
    fi
    printf " resolved to '$CMD'\n"
fi

CMD_REPO=https://raw.githubusercontent.com/xordeio/xc/main/cmd/$CMD.sh?$(date +%s)
printf "Getting $CMD_REPO...\n"
CMD_CODE=$(curl -H 'Cache-Control: no-cache' -s $CMD_REPO)

printf "Please confirm you want to run this code:\n\n$CMD_CODE\n\n(y/n)?"

old_stty_cfg=$(stty -g)
stty raw -echo; answer=$(head -c 1); stty $old_stty_cfg
if printf "$answer" | grep -iq "^y"; then
    printf "Yes\n"
    eval "$CMD_CODE";
else
    printf "No\n"
fi