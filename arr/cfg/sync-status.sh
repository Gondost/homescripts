#!/bin/bash

printf "Downloading or Incomplete:\n"
find /arr/dl/done/movies -mindepth 1 -type d -not -empty -name "_UNPACK*" -print
find /arr/dl/done/radarr_in -mindepth 1 -type d -not -empty -name "_UNPACK*" -print
find /arr/dl/done/tv -mindepth 1 -type d -not -empty -name "_UNPACK*" -print
find /arr/dl/done/sonarr_in -mindepth 1 -type d -not -empty -name "_UNPACK*" -print
find /arr/dl/pending -mindepth 1 -type d -not -empty -print
printf "To Manually Import to Sonarr:\n"
find /arr/dl/done/sonarr_in -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print
printf "Ready to Sync or Syncing:\n"
find /arr/dl/done/movies -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print
find /arr/dl/done/radarr_in -mindepth 1 -type d -not -empty -not -name "_UNPACK*" -print
find /arr/dl/done/radarr_out -mindepth 1 -type d -not -empty -print
find /arr/dl/done/sonarr_out -mindepth 1 -type d -not -empty -print
printf "Synced | Directories to be removed:\n"
find /arr/dl/done/movies -mindepth 1 -type d -empty -print
find /arr/dl/done/radarr_out -mindepth 1 -type d -empty -print
find /arr/dl/done/sonarr_out -mindepth 1 -type d -empty -print
