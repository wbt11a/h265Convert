#!/bin/bash
#source $HOME/.bash_profile

PID_OF_PROCESS=$(ps ax | grep [f]fmpeg | awk '{print $1}')
PLEX_TRANSCODER=$(ps ax | grep [T]ranscoder | awk '{print $1}')
PROCESS_PATH="/opt/downloads/Dark/convertScript.sh"
PID_OF_LAUNCHER=$(ps ax | grep [t]estScript | awk '{print $1}')
LOGGING="on"
PROGRESS="on"
if [ "$PLEX_TRANSCODER" ]; then
        if [ "$LOGGING" == "on" ]; then
                echo $(date) " - Plex transcoder running.  Suspending ffmpeg" >> runLog.txt
        fi
        kill -STOP "$PID_OF_PROCESS"
        exit 0
fi

if [ -z "$PID_OF_PROCESS" ] && [ -z "$PID_OF_LAUNCHER" ]; then

        if [ "$LOGGING" == "on" ]; then
                echo $(date) " - ffmpeg not running; starting work" >> runLog.txt
        fi

        if [ "$LOGGING" == "on" ]; then
                echo "creating lockfile at " $(dirname "$PROCESS_PATH")/start_lock.lock >> runLog.txt
                flock -n $(dirname "$PROCESS_PATH")/start_lock.lock /bin/bash "$PROCESS_PATH" >> runLog.txt 2>&1 || exit 1
        else
                flock -n $(dirname "$PROCESS_PATH")/start_lock.lock /bin/bash "$PROCESS_PATH" >> /dev/null 2>&1 || exit 1
        fi

else
        if [ "$LOGGING" == "on" ]; then
                echo $(date) " - ffmpeg already running.  Checking if suspended" >> runLog.txt
        fi
        PROCESS_STATUS=$(ps -o s= -p ${PID_OF_PROCESS})
        if [ "$PROCESS_STATUS" == "T" ]; then
                if [ "$LOGGING" == "on" ]; then
                        echo $(date) " - Process suspended.  Resuming." >> runLog.txt
                fi
                kill -CONT "$PID_OF_PROCESS"
        else
                if [ "$LOGGING" == "on" ]; then
                        echo $(date) " - Process already running normally" >> runLog.txt
                fi
                exit 0
        fi
fi


rm $(dirname "$PROCESS_PATH")/start_lock.lock
