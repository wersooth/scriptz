#!/usr/bin/env bash


case $1 in
start*)
    echo "** Launching Jenkins"
    sudo systemctl start jenkins
    echo "** Launching Nexus"
    nexus start
    echo "** Launching Gitlab docker image"
    docker run --detach --hostname mainh0ld.lan --publish 443:443 --publish 80:80 --publish 22:22 --name gitlab --restart always --volume /opt/gitlab/config:/etc/gitlab --volume /opt/gitlab/log:/var/log/gitlab --volume /mnt/ware.local/dev/gitlab_repo/:/var/opt/gitlab gitlab/gitlab-ce
    ;;
stop*)
    echo "** Stopping Jenkins"
    sudo systemctl stop jenkins
    echo "** Stopping Nexus"
    nexus stop
    echo "** Stopping Gitlab docker image"
    docker stop $(docker ps | grep "gitlab" | awk {' print $1 '})
    ;;
esac