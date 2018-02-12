#!/bin/bash
# shellcheck disable=SC1090
# Script Name: AtoMiC Nginx Location Enabler
# Author: TommyE123
# Publisher: http://www.htpcBeginner.com
# License: MIT License (refer to README.md for more details)

echo
if [[ $1 != 'SKIP' ]]; then
    source "$SCRIPTPATH/inc/app-setup-check.sh"
    source "$SCRIPTPATH/inc/commons.sh"
    source "$SCRIPTPATH/inc/header.sh"
fi

echo -e "${YELLOW}---> Copy Reverse Proxy file over.$ENDCOLOR"

if [[ $1 != 'SKIP' ]]; then
    source "$SCRIPTPATH/inc/pause.sh"
fi

if [[ -d /etc/nginx/ ]]; then
    if [[ -z $NGINXCONFNAME ]]; then
        NGINXCONFNAME="$APPNAME"
    fi

    source "$SCRIPTPATH/inc/app-stop.sh"

    if [[ ! -L "/etc/nginx/locations-enabled/$NGINXCONFNAME.atomic.conf" ]]; then
        if sudo ln -s "/etc/nginx/locations-available/$NGINXCONFNAME.atomic.conf" \
            "/etc/nginx/locations-enabled/$NGINXCONFNAME.atomic.conf"; then
            echo "Symlinked $NGINXCONFNAME.atomic.conf location file"
        fi
    else
        echo "Symlink for $NGINXCONFNAME.atomic.conf location already exists"
    fi

    if [[ -f $SCRIPTPATH/$APPNAME/$APPNAME-reverse-proxy-enable.sh ]]; then
        source "$SCRIPTPATH/$APPNAME/$APPNAME-reverse-proxy-enable.sh"
    fi

    sudo nginx -s reload

    source "$SCRIPTPATH/inc/app-start.sh"

    if [[ $1 != 'SKIP' ]]; then
        source "$SCRIPTPATH/inc/app-http-responses.sh"
    fi
else
    echo "Nginx not found. Please install via the Utils menu and then try again."
fi

if [[ $1 != 'SKIP' ]]; then
    source "$SCRIPTPATH/inc/thankyou.sh"
    source "$SCRIPTPATH/inc/exit.sh"
fi
