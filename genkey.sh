#!/usr/bin/env bash
#
# copyright serynooth wersuken 2019
#
# generate rsa keys with the parameter's filename.
# if no paramter exist, use the name: authkey

echo "***Generating 2048 bit RSA keys for authentication"
mkdir keys -p
if [ $# -eq 0 ]
then
  fo="authkey"
  echo "* No name provided, using" $fo
else
  fo=$1
fi
ssh-keygen -t rsa -b 2048 -f ./keys/$fo -P "" -q
echo "* Key generated:" $fo
