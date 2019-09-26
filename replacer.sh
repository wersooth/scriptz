#!/usr/bin/env bash
#
#   copyright serynooth wersuken 2019
#
#   replace the values in json, yml, yaml, ini and .dockerfiles, based on a key=value pair file as parapeter
#   Use @key@ in the target files.
#  
#


for p in $(cat $1)
do
    for f in $(find . -regextype posix-egrep -regex '(.+json)|(.+yml)|(.+yaml)|(.+ini)|(.+Dockerfile)')
    do
        sed -i -e "s,@${p:0:$(expr index $p '=')-1}@,${p:$(expr index $p '=')},g" $f
    done
done