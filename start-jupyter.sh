#!/bin/bash -e

# DOCKER_IMAGE=kripa4rk/jupyter-notebook:01.17.2019
DOCKER_IMAGE=miniconda:latest

docker pull $DOCKER_IMAGE || true

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ `docker images -q $DOCKER_IMAGE` == "" ]]
then
  docker build . -t $DOCKER_IMAGE
  docker push $DOCKER_IMAGE
fi

docker run --name jupyter -it -v $(pwd)/../:/opt/notebooks --rm -d -p 80:8888 -p 28892:28892 $DOCKER_IMAGE
sleep 2
open http://localhost
trap "docker kill jupyter" INT TERM EXIT SIGHUP
read -p "Press Return to Close..."