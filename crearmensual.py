#-*-coding:utf8-*-
from fabric.api import local

bases = {'bdSueldos', 'des_bdSueldos', 'des_toba_2_3_4', 
			 'des_Lmunictes', 'Lmunictes', 'pilaga_2014', 
			 'pilaga_2015', 'toba_2_3_4', 'toba_pilaga_2014',
			 'toba_pilaga_2015', 'pilaga_2013'} 
for base in bases:
    local('mkdir /bases/dir_%s/mensual' % base)


	
