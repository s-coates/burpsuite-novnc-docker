#!/bin/bash
set -ex

# Export HOME in order to ensure Chromium knows where to point to
export HOME="${HOME}"

# Define default variables
HOME=${HOME}
ACTIVATE=${ACTIVATE:-no}
RUN_NOVNC=${RUN_NOVNC:-yes}
RUN_SUPERVISORD=${RUN_SUPERVISORD:-yes}

# If we are activating then run the activate script
case $ACTIVATE in
  true|yes|y|1)
	echo "-- Activating BurpSuite --"
	expect $HOME/app/activate.sh
	tail -f /dev/null
	;;
esac

# If we are not running novnc then remove the novnc specific jobs
case $RUN_NOVNC in
  false|no|n|0)
    rm -f $HOME/app/conf.d/websockify.conf
    rm -f $HOME/app/conf.d/fluxbox.conf
    rm -f $HOME/app/conf.d/x11vnc.conf
    rm -f $HOME/app/conf.d/xterm.conf
    rm -f $HOME/app/conf.d/xvbc.conf
    rm -f $HOME/app/conf.d/burpsuitegui.conf
    ;;
esac

# If we are running novnc then remove the burpsuite headless job
case $RUN_NOVNC in
  true|yes|y|1)
    rm -f $HOME/app/conf.d/burpsuiteheadless.conf
    ;;
esac

# Optionally lanuch supervisord as root in order to run background jobs
case $RUN_SUPERVISORD in
  true|yes|y|1)
	echo "-- Starting Background Jobs --"
	exec sudo supervisord -c $HOME/app/supervisord.conf
    ;;
esac

# stall the container if we are not running supervisord
tail /dev/null