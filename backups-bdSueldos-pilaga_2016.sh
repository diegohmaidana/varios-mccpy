#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/PostgreSQL/9.2/bin/:/opt/PostgreSQL/9.2/data
cd /home/scripts
# Backup de bdSueldos y pilaga_2016
fab -H 192.168.10.181 backup_base:bdSueldos
fab -H 192.168.10.181 backup_base:pilaga_2016
touch funciona.txt
