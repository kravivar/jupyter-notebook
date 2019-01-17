#!/bin/bash

cd /root
source activate py3 
cat /etc/hosts | sed 's/::1.*/::1 ip6-localhost ip6-loopback/g' > /tmp/hosts
cat /tmp/hosts > /etc/hosts 
jupyter notebook --NotebookApp.token= --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root