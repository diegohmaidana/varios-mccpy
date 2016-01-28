#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/PostgreSQL/9.2/bin/:/opt/PostgreSQL/9.2/data
cd /home/scripts

# Backups de las bases del 181
fab -H 192.168.10.181 backup_base:Lmunictes
fab -H 192.168.10.181 backup_base:pilaga_2014
fab -H 192.168.10.181 backup_base:pilaga_2015
fab -H 192.168.10.181 backup_base:toba_pilaga_2014
fab -H 192.168.10.181 backup_base:toba_pilaga_2016
fab -H 192.168.10.181 backup_base:toba_pilaga_2015
fab -H 192.168.10.181 backup_base:toba_2_3_4

#Backups de las bases del 200
fab -H 172.25.50.200 backup_base:Lmunictes,True
fab -H 172.25.50.200 backup_base:bdSueldos,True
fab -H 172.25.50.200 backup_base:toba_2_3_4,True
fab -H 172.25.50.200 backup_base:mapas,True

#Backup de las base del 169 (pilaga 2013) 
fab -H 192.168.10.169 backup_base:pilaga_2013

#Comprimir y Ordenar todo.
fab ordenar_diario
