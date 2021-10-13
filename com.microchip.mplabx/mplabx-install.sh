#!/bin/sh

export PATH=/bin:/app/bin:/app/jre/bin
export JAVA_HOME=/app/jre

tmp/installer.run --mode unattended &> /dev/null

exit 0
