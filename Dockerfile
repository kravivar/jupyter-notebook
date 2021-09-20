FROM continuumio/miniconda3:4.10.3-alpine

# Copy files
COPY ./jupyter.sh /root
COPY ./requirements.txt /root

# Port
ENV PORT=8888

WORKDIR /root 
RUN apk update
RUN apk add mesa-gl libgomp wget openssh-client

# Install miniconda
RUN conda update -n root conda -y --quiet

# Create python3 environment and install packages with tensorflow cpu
RUN conda create -n py3 python=3 ipykernel pip -y
RUN /bin/bash -c "source activate py3 && pip install -r /root/requirements.txt"

# Install kernels for jupyter
RUN /bin/bash -c "source activate py3 && ipython kernel install --user"


RUN mkdir /opt/notebooks

EXPOSE 8888 

ENTRYPOINT /bin/bash /root/jupyter.sh 