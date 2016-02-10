#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

import os
import locale
import shutil
from datetime import date, timedelta

path_inicio = '/bases/'
meses = {'ene', 'feb', 'mar', 'abr',
         'may', 'jun', 'jul', 'ago',
         'sep', 'oct', 'nov', 'dic'
         }


def borrar_meses_ant():
    ''' Busca y borra las carpetas mensuales, menos del mes anterior
    '''
    locale.setlocale(locale.LC_ALL, "")
    # Obtine el mes anterior como string
    mes_anterior = (date.today() - timedelta(days=28)).strftime('%b')
    for base, dirs, files in os.walk(path_inicio):
        if dirs != []:
            for dir in dirs:
                if (dir in meses) and (dir != mes_anterior):
                    shutil.rmtree(base + '/' + dir)


if __name__ == '__main__':
    borrar_meses_ant()
