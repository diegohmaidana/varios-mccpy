#! /usr/bin/python

import telnetlib

HOST = "172.25.21.11"
password = "bGp.34.408"
tn = telnetlib.Telnet(HOST)
tn.read_until("Password:")
tn.write(password + "\n")
tn.write("r\n")
