#!/bin/bash
echo
echo
nmap -Pn $1 -p 25,587,465,2525 --script smtp-realy
