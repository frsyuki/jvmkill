#!/bin/bash
set -ex

JVMKILL_VERSION=${JVMKILL_VERSION:-8214df6de53d0f8aaf47d032cb1aa047671af0ce}
export JAVA_HOME="${JAVA_HOME:-$(readlink -f $(which javac) | sed s:/bin/javac::)}"

# Ubuntu
apt-get update

apt-get install -y wget unzip gcc make
apt-mark auto wget unzip gcc make

wget -O jvmkill-${JVMKILL_VERSION}.zip "https://github.com/airlift/jvmkill/archive/${JVMKILL_VERSION}.zip"
unzip jvmkill-${JVMKILL_VERSION}.zip
cd jvmkill-${JVMKILL_VERSION}
make
make test  2>&1 | grep -q "killing current process"
install -m 755 libjvmkill.so /usr/local/lib
cd ..

rm -rf jvmkill-${JVMKILL_VERSION} jvmkill-${JVMKILL_VERSION}.zip
apt-get autoremove --purge -y
rm -rf /var/lib/apt/lists/*

rm -f install_jvmkill.sh

