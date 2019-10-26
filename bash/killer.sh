#!/usr/bin/env bash

ps ax | grep $1 | awk '{ print $1}' | xargs kill -9
echo "$1 processes killed"

