#!/bin/sh

git_log_options=$*

git log \
  | awk '/Author:/{print$2}' \
  | sort -u \
  | xargs -n1 -I@ echo 'git log --author=@ --shortstat '"$git_log_options"' | awk -F, '"'"'/files changed/{c += $2-$3} END{print "@: "c}'"'"'' \
  | sh
