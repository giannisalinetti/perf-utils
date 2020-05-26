#!/bin/sh
# Start pmcd in the background

exec=/usr/share/pcp/lib/pmcd
pidfile=/run/pcp/pmcd.pid

if [ ! -d $pcpdir ]; then
    mkdir $pcpdir
fi 

case "$1" in
    start)
        pmcd_exists=`pidof pmcd`
        if [ ! -z ${pmcd_exists} ]; then
	    echo "Pmcd is already running on the host"
            exit 0
        fi

	if [ ! -f $pidfile ]; then
            echo "Starting pmcd..."
	    nohup $exec start > /dev/null 2>&1 &
            sleep 3
	    echo `pidof pmcd` > $pidfile
	else
	    echo "Pmcd already started in the perf-utils container"
	fi
        ;;
    stop)
        echo "Stopping pmcd..."
        if [ -f $pidfile ]; then
            kill $(cat $pidfile) && rm -f $pidfile
        fi
        ;;
    -h|--help)
      # Print help 
      echo "Usage:"
      echo "  $(basename $0) start|stop"
      ;;
    *)
    ;;
esac 

exit 0

