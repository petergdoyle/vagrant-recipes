#!/bin/sh

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
