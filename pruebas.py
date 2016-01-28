#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

from fabric.api import run,env

env.hosts = ['192.168.10.150']

def ls():
	result = run('ls -l /var')
	

if __name__ == "__main__":
	ls()
	



