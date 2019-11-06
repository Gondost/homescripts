#!/bin/bash

MOVIEDIR="/arr/dl/done/radarr_out"
TVDIR="/arr/dl/done/sonarr_out"
MOVIESTOSYNCSZ=`find $MOVIEDIR -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print`
MOVIESTOSYNCRR=`find $MOVIEDIR -mindepth 1 -type f -not -name "*.partial~" -print`
TVTOSYNCSZ=`find $TVDIR -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print`
TVTOSYNCSR=`find $TVDIR -mindepth 1 -type f -not -name "*.partial~" -print`

# Sabnzbd movie done directory
if [[ "$MOVIESTOSYNCSZ" != "" || "$MOVIESTOSYNCRR" != "" ]]; then
        echo "INFO: $MOVIEDIR has items to sync, checking rclone move status"
        RCLONEMOVESTATUS=`ps -ef | grep "rclone move" | grep -v 'grep'`
        if [[ "$RCLONEMOVESTATUS" != "" ]]; then
                echo "INFO: rclone move already running, skipping sync"
        else
                echo "INFO: rclone move inactive, running on $MOVIEDIR"
                rclone move $MOVIEDIR gc_one:/media/movies\
                 -P --transfers 2 --exclude "/*unpack*/**" --exclude "*.partial~"\
                 --ignore-case --fast-list --delete-empty-src-dirs\
                 && find $MOVIEDIR -mindepth 1 -type d -empty -print -delete
        fi
else
        echo "INFO: $MOVIEDIR has no eligible items to move"
fi

# Sonarr sorted TV shows directory
if [[ "$TVTOSYNCSZ" != "" || "$TVTOSYNCSR" != "" ]]; then
        echo "INFO: $TVDIR has items to sync, checking rclone move status"
        RCLONEMOVESTATUS=`ps -ef | grep "rclone move" | grep -v 'grep'`
        if [[ "$RCLONEMOVESTATUS" != "" ]]; then
                echo "INFO: rclone move already running, skipping sync"
        else
                echo "INFO: rclone move inactive, running on $TVDIR"
                rclone move $TVDIR gc_one:/media/tv\
                 -P --transfers 4 --exclude "/*unpack*/**" --exclude "*.partial~"\
                 --ignore-case --fast-list --delete-empty-src-dirs\
                 && find $TVDIR -mindepth 1 -type d -empty -print -delete
        fi
else
        echo "INFO: $TVDIR has no eligible items to move"
fi
