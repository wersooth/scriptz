#!/usr/bin/env bash

while true; do
  inotifywait -r -e modify,attrib,close_write,move,create,delete /home/anselm/src/ksp/blastaerotech/blender
  sleep 1
  rsync -auvz --exclude "*.blend*"  /home/anselm/src/ksp/blastaerotech/blender/ '/home/anselm/src/ksp/blastaerotech/unity/Blast KPS ModPack/Assets/blast-aerospace'
done
