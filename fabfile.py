#fabfile.py
#-*-coding:utf8-*-

from __future__ import with_statement
from fabric.decorators import task
from fabric.api import run, local, lcd, settings, cd, prompt
from datetime import date, timedelta
import time
import locale

bases = {'bdSueldos', 'des_bdSueldos', 'des_toba_2_3_4', 'des_Lmunictes',
         'Lmunictes', 'pilaga_2015', 'pilaga_2014', 'toba_2_3_4',
         'toba_pilaga_2014', 'toba_pilaga_2015', 'pilaga_2013', 
	 'des_mapas', 'toba_pilaga_2016', 'pilaga_2016'}
routers = {'172.25.0.6':'Interno', '172.25.0.5':'Externo',
		   '172.25.100.3':'ATF', '172.25.100.4':'DesUrbano',
		   '172.25.0.1':'OSP', '172.25.0.9':'Transito',
		   '172.25.50.254':'SSI-B', '172.25.27.254':'SSI-A'}
servers = {'305':'PostgreSql','101':'Correo-ACOR', '220':'Pilaga-2015',
		   '103':'TelefoniaIp', '104':'Produccion', '105':'FreeNas',
		   '106':'Correos', '107':'Gis', '109': 'Desarrollo',
		   '110':'Monitoreo', '111':'Geoserver', '113':'Pilaga-2014', 
		   '114':'Desarrollo-Sueldos', '108':'TelefoniaIp-COM', 
		   '117':'TelefoniaIp-OSP', '119':'Pilaga-pruebas', '102':'Glpi'} 
# El Fortigate lo hago manual, por ahora
pass_routers = 'lomito1810*'


def agregar_base(nombre):
	pass


def agregar_router(ip):
	pass


def listar_bases():
	pass


def listar_routers():
	pass


@task
def backup_base(base, es_des=False):	
	'''
	Realiza un copia de la base, formatea el nombre y la almacena en /bases.

	Parametros que recibe: 
	El nombre de la base de datos y un boleano (es de desarrollo?)

	Ejemlo:
			fab -H 192.168.10.181 backup_base:bdsueldos			
	'''
	nombre_backup = base
	if es_des:
		nombre_backup = 'des_' + base
	run('pg_dump -x --disable-triggers -h localhost -p5432 -i -U postgres %s > \
		/var/backups/%s' % (base, nombre_backup))
	
	run('scp /var/backups/%s root@172.25.50.150:/bases' % nombre_backup)
	# Borrar el archivo local 


@task
def backup_vm(id):
	'''
	Realiza una copia de la VM en modo Stop.(recibe el ID)
	'''
	id = str(id)
	with cd('/var/lib/vz/dump'):
		run('qm stop %s' % id)
		with settings(warn_only=True):
			run('rm %s*' % servers[id]) #Borra backup anterior
			# falta capturar el error
		run('vzdump %s -mode stop -compress gzip -storage backups' % id)
		run('qm start %s' % id)
		run('rm *.log')
		nombre = formatear_nombre(servers[id], True) #Arma el nombre con fecha y demas
		run('mv *%s* %s' % (id, nombre)) #Renombra el archivo de backup
		run('scp /var/lib/vz/dump/%s root@172.25.50.150:/virtuales' % nombre)


@task
def backups_vms():
	lista_vms = servers.keys()
	for vm in lista_vms:
		if vm == '305' or vm == '108' or vm == '117':
			continue
		backup_vm(vm)

@task
def actualizar_tractas():
	with cd('/root/scripts_automotores'):
		run('psql -h localhost -p5432 -U postgres --dbname=bdSueldos < \
		 	actualizar_automotores_insert.sql')
		run('psql -h localhost -p5432 -U postgres --dbname=bdSueldos < \
		 	actualizar_motos_insert.sql')


@task
def actualizar_neike():
	with cd('/root'):
		run('psql -h localhost -p5432 -U postgres --dbname=bdSueldos < per_neike.sql')


@task
def formatear_nombre(nombre_archivo, es_vm=False):
    locale.setlocale(locale.LC_ALL,"")
    fecha = '_'+time.strftime('%d-%b-%Y')
    nombre = nombre_archivo+fecha
    if es_vm:
    	nombre = nombre+'.vma.gz' 
    return nombre
	

@task
def ordenar_diario():
	'''
	Ordena los backups de las bases, comprimiendolos en su carpeta diario 
	'''
	for base in bases:
		nombre = formatear_nombre(base)
		with lcd('/bases'):
			with settings(warn_only=True):
				result = local('tar -zcvf %s.tgz %s' % (nombre, base), capture=True)
			if not result.failed:
				local('mv %s.tgz /bases/dir_%s/diario' % (nombre, base))
			else:
				continue
		if date.today().strftime('%d') == '01':
			ordenar_mensual(base)


@task
def ordenar_mensual(base):
	locale.setlocale(locale.LC_ALL,"")
	mes_anterior = (date.today() - timedelta(days=28)).strftime('%b')
	with lcd('/bases/dir_%s' % base):
		local('mkdir mensual/%s' % mes_anterior)
		local('mv diario/*%s* mensual/%s' % (mes_anterior, mes_anterior))


@task
def backup_router(ip):
	with lcd('/comunicaciones'):
		local('ncftpget -u admin -p %s ftp://%s:/%s.backup' % (pass_routers, ip,
		      routers[ip]))


@task
def backups_routers():
	with lcd('/comunicaciones'):
		local('mv *.backup backups-routers-30dias') 
		lista_routers = routers.keys()
		for r in lista_routers:
			backup_router(r)

'''
@task
def listar(id):
	with settings(warn_only=True):
		result = local('ls %s*' % servers[id], capture=True)
	if result.failed:
		print result.command 
	prompt('hola')
'''
