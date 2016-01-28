#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/PostgreSQL/9.2/bin/:/opt/PostgreSQL/9.2/data
cd /home/scripts
fab -H 192.168.10.181 actualizar_tractas 
