#!/bin/sh


find / -name '.bash_history' -exec rm -v {} \;
history -c

shutdown -h now
