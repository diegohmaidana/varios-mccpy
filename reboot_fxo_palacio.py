#! /usr/bin/python

import telnetlib

HOST = "172.25.27.50"
password = "admin"
tn = telnetlib.Telnet(HOST)
tn.read_until("Password:")
tn.write(password + "\n")
tn.write("r\n")