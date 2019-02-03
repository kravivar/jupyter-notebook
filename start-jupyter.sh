#!/bin/bash -e

_VERSION="0.6.0"

if [ $USE_GPU ]
then
	DOCKER_IMAGE=kripa4rk/jupyter-notebook:gpu-${_VERSION}
else
	DOCKER_IMAGE=kripa4rk/jupyter-notebook:cpu-${_VERSION}
fi

docker pull $DOCKER_IMAGE

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### Since the build is moved to dockerhub no longer need this section. 
# if [[ `docker images -q $DOCKER_IMAGE` == "" ]]
# then
#   docker build . -t $DOCKER_IMAGE
#   docker push $DOCKER_IMAGE
# fi

if [ $USE_GPU ]
then
	echo "Running in GPU mode ..."
	docker run --runtime=nvidia --name jupyter -it -v $(pwd)/../:/opt/notebooks --rm -d -p 80:8888 -p 28892:28892 $DOCKER_IMAGE
else
	echo "Running in CPU mode ..."
	docker run --name jupyter -it -v $(pwd)/../:/opt/notebooks --rm -d -p 80:8888 -p 28892:28892 $DOCKER_IMAGE
	sleep 2
	open http://localhost
	trap "docker kill jupyter" INT TERM EXIT SIGHUP
	read -p "Press Return to Close..."	
fi