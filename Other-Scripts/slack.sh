#!/bin/bash

# This script is for fixing Slack ICON
# https://github.com/flathub/com.slack.Slack/issues/37#issuecomment-606539095

function changeWinIco
{
  # Get line like this - 0x1c00002 "Slack |
  slackWinInfo=$(xwininfo -tree -root | grep -o '^.*\s\WSlack\s|\W')
  # Put two parts splitted by space into array
  IFS=" " read -a winInfoArr <<< "$slackWinInfo"
  # Win ID is the 1st item of an array
  slackWinID=${winInfoArr[0]}
  # If slack`s win was found then Win ID will not empty
  if [ -n "$slackWinID" ]; then
    # Set icon and exit from func
    xseticon -id $slackWinID $HOME/.icons/slack.png
    exit
  fi
  # Else w8 for 2 seconds and start func again
  sleep 2; changeWinIco
}

# Start slack application and run func the 1st time
slack & changeWinIco