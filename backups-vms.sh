#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
mv /virtuales/*.gz /virtuales/temporales

cd /home/scripts
fab -H 172.25.50.192 backups_vms
fab -H 172.25.50.193 backup_vm:305
fab -H 172.25.21.1 backup_vm:108
fab -H 172.25.8.1 backup_vm:117
