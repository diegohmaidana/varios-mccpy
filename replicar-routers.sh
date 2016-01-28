#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/g$
cd /home/scripts

rsync -avz -e ssh /comunicaciones/ root@172.25.21.1:/var/lib/vz/backups/comunicaciones
