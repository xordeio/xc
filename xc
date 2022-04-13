#!/bin/sh

CMD=$1
SELF=$0

if [ "$TERM" = xterm ] || [ "$TERM" = xterm-256color ]; then 
    export TERM=xterm-256color; 
    COLOR_NC='\e[0m' # No Color
    COLOR_BLACK='\e[0;30m'
    COLOR_GRAY='\e[1;30m'
    COLOR_RED='\e[0;31m'
    COLOR_LIGHT_RED='\e[1;31m'
    COLOR_GREEN='\e[0;32m'
    COLOR_LIGHT_GREEN='\e[1;32m'
    COLOR_BROWN='\e[0;33m'
    COLOR_YELLOW='\e[1;33m'
    COLOR_BLUE='\e[0;34m'
    COLOR_LIGHT_BLUE='\e[1;34m'
    COLOR_PURPLE='\e[0;35m'
    COLOR_LIGHT_PURPLE='\e[1;35m'
    COLOR_CYAN='\e[0;36m'
    COLOR_LIGHT_CYAN='\e[1;36m'
    COLOR_LIGHT_GRAY='\e[0;37m'
    COLOR_WHITE='\e[1;37m'
fi

### show help if no arguments
if [ $# -eq 0 ]; then
  printf "${COLOR_RED}Error: No arguments supplied${COLOR_NC}\n\n" >&2
  printf "\
${COLOR_WHITE}POSIX-compliant collection of scripts for systems administration${COLOR_NC}

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
"
  exit 1
fi

### check if CMD is numeric code:
if [ -n "$CMD" ] && [ "$CMD" -eq "$CMD" ] 2>/dev/null; then
        printf "Resolving numeric shortcut..."
    if [ "$CMD" -eq "1" ]; then
        CMD=update
    else
        SHORTCUTS=$(curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/xordeio/xc/main/shortcuts.txt)
        CMD=$(echo "$SHORTCUTS" | grep -Po "(?<=^$1=)\w*$")
    fi
    printf " resolved to '$CMD'\n"
fi

CMD_REPO=https://raw.githubusercontent.com/xordeio/xc/main/cmd/$CMD.sh?$(date +%s)
printf "Getting $CMD_REPO...\n"
CMD_CODE=$(curl --fail -H 'Cache-Control: no-cache' -s $CMD_REPO 2>&1)

if [ $? -ne 0 ]; then
    case $? in
        22) ERROR=Command not found
        6) ERROR=Network error
        *) ERROR=Error code $?
    esac
    printf "${COLOR_RED}Error: $ERROR${COLOR_NC}\n"
    exit 2
fi

printf "${COLOR_YELLOW}Please confirm you want to run this code:\n\n${COLOR_GREEN}$CMD_CODE${COLOR_NC}\n\n(y/n)?"

old_stty_cfg=$(stty -g)
stty raw -echo; answer=$(head -c 1); stty $old_stty_cfg
if printf "$answer" | grep -iq "^y"; then
    printf "Yes\n"
    eval "$CMD_CODE";
else
    printf "No\n"
fi
