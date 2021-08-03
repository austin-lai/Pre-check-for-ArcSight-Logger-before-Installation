#!/bin/bash

{
    sleep 2
    set -x

    if [[ $EUID -ne 0 ]]; then
        sleep 2
        echo "This script require to run as root"
        exit 1
    else
        sleep 2
        echo "This script run as root"

        sleep 2
        cat /etc/redhat-release

        sleep 2
        sudo yum --enablerepo=updates clean metadata

        sleep 2
        sudo yum install -y centos-release-scl

        sleep 2
        sudo yum-config-manager --enable epel

        sleep 2
        sudo yum --enablerepo=extras install -y epel-release

        sleep 2
        sudo yum install -y epel-release

        sleep 2
        sudo yum install -y https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm

        sleep 2
        sudo yum install -y ius-release

        sleep 2
        sudo yum --enablerepo=updates clean metadata

        sleep 5
        sudo yum check-update -y

        sleep 2
        sudo yum update -y 

        sleep 2
        sudo yum upgrade -y

        sleep 2
        yum install -y unzip zip

        sleep 2
        yum install -y fontconfig \ dejavu-sans-fonts

        
        if [ $(getent group arcsight) ]; then
            sleep 2
            echo $(getent group arcsight)" = exists."
        else
            sleep 2
            echo $(getent group arcsight)" = not exists."

            sleep 2
            groupadd –g 750 arcsight
        fi

        # Or use "id -u arcsight" also can
        if [ $(getent passwd arcsight) ]; then
            sleep 2
            echo $(getent passwd arcsight)" = exists."
        else
            sleep 2
            echo $(getent passwd arcsight)" = not exists."

            sleep 2
            useradd –m –g arcsight –u 1500 arcsight
        fi

        # If install as non-root user need to grant user for below folder
        # sleep 2
        # chown -R arcsight:arcsight /opt/arcsight

        sleep 2
        hostname

        sleep 2
        hostnamectl set-hostname arcsight.logger.30072019

        sleep 2
        cat /etc/security/limits.d/20-nproc.conf

        sleep 2
        cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.bak

        sleep 2
        sed -i.bak '/soft/d' /etc/security/limits.d/20-nproc.conf


        # If change this at least need to log out and login again
        # or reboot
        if sudo cat /etc/security/limits.d/20-nproc.conf | grep 'nproc' ; then
            sleep 2
            echo "cat /etc/security/limits.d/20-nproc.conf | grep 'nproc' matched!"
    
            sleep 2
            cat /etc/security/limits.d/20-nproc.conf
        else
            sleep 2
            echo "cat /etc/security/limits.d/20-nproc.conf | grep 'nproc' not matched!"
            
            sleep 2
            echo "* soft nproc 10240" >> /etc/security/limits.d/20-nproc.conf

            sleep 2
            echo "* hard nproc 10240" >> /etc/security/limits.d/20-nproc.conf

            sleep 2
            echo "* soft nofile 65536" >> /etc/security/limits.d/20-nproc.conf

            sleep 2
            echo "* hard nofile 65536" >> /etc/security/limits.d/20-nproc.conf

            sleep 2
            cat /etc/security/limits.d/20-nproc.conf
        fi


        if sudo cat /etc/systemd/logind.conf | grep '#RemoveIPC' ; then
            sleep 2
            echo "cat /etc/systemd/logind.conf | grep '#RemoveIPC' matched!"
            
            sleep 2
            sed -i.bak 's/#RemoveIPC=no/RemoveIPC=no/' /etc/systemd/logind.conf
            
            sleep 2
            cat /etc/systemd/logind.conf | grep 'RemoveIPC'
        else
            sleep 2
            echo "cat /etc/systemd/logind.conf | grep '#RemoveIPC' not matched!"
            
            sleep 2
            cat /etc/systemd/logind.conf | grep 'RemoveIPC'
        fi

        sleep 2
        systemctl restart systemd-logind.service

        sleep 2
        updatedb

        # find ArcSight Logger installation file
        sleep 2
        find_logger=`locate ArcSight-l`

        sleep 2
        chmod u+x $find_logger

        sleep 2
        ls -l $find_logger

        sleep 2
        service firewalld status

        # You can choose to disable firewalld and disable on boot
        # Or you can add in iptables rule to allow mainly tcp 443
        # And any other port require if using dns,ntp,cifs,syslog
        sleep 2
        firewall-cmd --list-all

        sleep 2
        firewall-cmd --zone=public --add-service=https

        sleep 2
        firewall-cmd --zone=public --permanent --add-service=https

        sleep 2
        firewall-cmd --reload

        # To start logger installation with console mode
        # sleep 2
        # ./ArcSight-logger-6.7.L8242.0.bin -i console


    fi

    set +x

} 2>&1 | tee log.out
