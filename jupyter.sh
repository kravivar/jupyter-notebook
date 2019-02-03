#!/bin/bash

_PORT=8888

if [ ! -z $PORT ]
then
	_PORT=$PORT
fi

cd /root
source activate py3 
cat /etc/hosts | sed 's/::1.*/::1 ip6-localhost ip6-loopback/g' > /tmp/hosts
cat /tmp/hosts > /etc/hosts 
jupyter notebook --NotebookApp.token= --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=${_PORT} --no-browser --allow-root