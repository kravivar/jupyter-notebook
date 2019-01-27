#!/bin/bash -e

DOCKER_IMAGE=kripa4rk/jupyter-notebook:01.27.2019

docker pull $DOCKER_IMAGE

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### Since the build is moved to dockerhub no longer need this section. 
# if [[ `docker images -q $DOCKER_IMAGE` == "" ]]
# then
#   docker build . -t $DOCKER_IMAGE
#   docker push $DOCKER_IMAGE
# fi

docker run --name jupyter -it -v $(pwd)/../:/opt/notebooks --rm -d -p 80:8888 -p 28892:28892 $DOCKER_IMAGE
sleep 2
open http://localhost
trap "docker kill jupyter" INT TERM EXIT SIGHUP
read -p "Press Return to Close..."