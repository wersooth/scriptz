#!/usr/bin/env bash

#
# 	Context changer
#
#	Change kubernetes context, based on params
#
#	author: laszlo.enzsel@
#
#

help() {
cat <<EOF
Usage: ${0##*/} [-h] [ -t TARGET ] [ -r REGION ] [ CLUSTERNAME ]
Change the context of the current kubectl configuration. 
	-h 	Help, this text.
	-t 	Set target of the Cluster. Default is aws.
		Possible values: aws, local
	-r  Set region of the cluster. Default is us-east-1.
		Only used if target is aws.
EOF
}

if [ -z `which kubectl` ]; then
	echo "ERROR! Couldn't locate kubectl! Please install kubectl to update kubeconfig!"
	exit 1
fi 

# set defaults and  variables
REGION="us-east-1"
CLUSTERNAME=""
TARGET="aws"

while getopts :hr:c:t: opt; 
do
	case $opt in
	h)
		help
		exit 0
		;;
	r)
		REGION=$OPTARG
		;;
	c)
		CLUSTERNAME=$OPTARG
		;;
	t)
		TARGET=$OPTARG
		;;
	:)
		echo "option $OPTARG requires parameter!"
		case $OPTARG in
			r)
				echo "ERROR! No Region defined!"
				help
				exit 1
				;;
			t)
				echo "ERROR! No target defined!"
				help
				exit 1
				;;
		esac
		echo "Usage: chcontext.sh [-r region default=us-east-1] -c clustername"
		exit 1
	esac
done
shift "$((OPTIND-1))" 

if [ -z "$@" ]; then	
	echo "ERROR! No Clustername defined!"
	help
	exit 1
else
	CLUSTERNAME="$@"
fi

echo "CHANGING CONTEXT"
echo "TARGET=$TARGET"
echo "REGION=$REGION"
echo "CLUSTERNAME=$CLUSTERNAME"

case $TARGET in 
	aws)
		echo "aws eks config"
		if [ -z `which aws` ]; then
			echo "ERROR! Couldn't locate AWS CLI! Please install aws-cli to update kubeconfig!"
			exit 1
		else 
			`aws eks --region $REGION update-kubeconfig --name $CLUSTERNAME2`
		fi 
		exit 0
		;;
	local)
		echo "change local config"
		exit 0
		;;
esac