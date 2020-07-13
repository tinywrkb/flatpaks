#!/bin/sh

export PATH=/bin:/app/bin:/app/jre/bin
export JAVA_HOME=/app/jre

catch {tmp/installer.run --mode unattended}

exit 0
