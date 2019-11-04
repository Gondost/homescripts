#!/bin/bash

SABMOVIEDIR="/arr/dl/done/movies"
SONARRDIR="/arr/dl/done/sonarr_out"
MOVIESTOSYNCSZ=`find $SABMOVIEDIR -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print`
MOVIESTOSYNCRR=`find $SABMOVIEDIR -mindepth 1 -type f -not -name "*.partial~" -print`
TVTOSYNCSZ=`find $SONARRDIR -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print`
TVTOSYNCRR=`find $SONARRDIR -mindepth 1 -type f -not -name "*.partial~" -print`

# Sabnzbd movie done directory
if [[ "$MOVIESTOSYNCSZ" != "" || "$MOVIESTOSYNCRR" != "" ]]; then
        echo "INFO: $SABMOVIEDIR has items to sync, checking rclone move status"
        RCLONEMOVESTATUS=`ps -ef | grep "rclone move" | grep -v 'grep'`
        if [[ "$RCLONEMOVESTATUS" != "" ]]; then
                echo "INFO: rclone move already running, skipping sync"
        else
                echo "INFO: rclone move inactive, running on $SABMOVIEDIR"
                rclone move $SABMOVIEDIR gc_one:/media/movies\
                 -P -v --transfers 1 --exclude "/*unpack*/**" --exclude "*.partial~"\
                 --ignore-case --fast-list --delete-empty-src-dirs\
                 && find $SABMOVIEDIR -mindepth 1 -type d -empty -print -delete
        fi
else
        echo "INFO: $SABMOVIEDIR has no eligible items to move"
fi

# Sonarr sorted TV shows directory
if [[ "$TVTOSYNCSZ" != "" || "$TVTOSYNCRR" != "" ]]; then
        echo "INFO: $SONARRDIR has items to sync, checking rclone move status"
        RCLONEMOVESTATUS=`ps -ef | grep "rclone move" | grep -v 'grep'`
        if [[ "$RCLONEMOVERSTATUS" != "" ]]; then
                echo "INFO: rclone move already running, skipping sync"
        else
                echo "INFO: rclone move inactive, running on $SONARRDIR"
                rclone move $SONARRDIR gc_one:/media/tv\
                 -P -v --transfers 2 --exclude "/*unpack*/**" --exclude "*.partial~"\
                 --ignore-case --fast-list --delete-empty-src-dirs\
                 && find $SONARRDIR -mindepth 1 -type d -empty -print -delete
        fi
else
        echo "INFO: $SONARRDIR has no eligible items to move"
fi
