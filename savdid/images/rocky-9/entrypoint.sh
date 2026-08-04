#!/bin/sh
set -e

pidfile="/var/run/savdid/savdid.pid"
reloadfile="/var/sav/vdbs/.reload"
logdir="/var/log/savdid"
stopping=false

signal_savdid()
{
    signal="$1"

    if [ -r "$pidfile" ]; then
        signal_pid="$(cat "$pidfile")"
        kill "-$signal" "$signal_pid" 2>/dev/null || true
    fi
}

read_reloadfile()
{
    cat "$reloadfile" 2>/dev/null || true
}

trap 'stopping=true; signal_savdid TERM' INT TERM
trap 'signal_savdid HUP' HUP

rm -f "$pidfile"
"$@"
sleep 1

reload="$(read_reloadfile)"

pid="$(cat "$pidfile")"
current_logfile=""
tail_pid=""

while kill -0 "$pid" 2>/dev/null; do
    sleep 1 &
    wait $! || true

    logfile="$logdir/$(date -u +%y%m%d).log"
    if [ "$logfile" != "$current_logfile" ] && [ -f "$logfile" ]; then
        previous_tail_pid="$tail_pid"

        tail -n +1 -F "$logfile" &
        tail_pid=$!

        if [ -n "$previous_tail_pid" ]; then
            kill "$previous_tail_pid" 2>/dev/null || true
            wait "$previous_tail_pid" 2>/dev/null || true
        fi

        if [ -n "$current_logfile" ]; then
            rm -f "$current_logfile"
        fi

        current_logfile="$logfile"
    fi

    current="$(read_reloadfile)"
    if [ "$current" != "$reload" ]; then
        reload="$current"
        signal_savdid HUP
    fi
done

if [ "$stopping" = false ]; then
    exit 1
fi
