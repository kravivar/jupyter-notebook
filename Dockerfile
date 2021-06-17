FROM continuumio/miniconda3

# Port
ENV PORT=8888

WORKDIR /root 
RUN apt-get update -y
RUN apt-get install wget libgomp1 libgl1-mesa-glx -y

# Install miniconda
RUN conda update -n root conda -y --quiet

# Create python3 environment and install packages with tensorflow cpu
RUN conda create -n py3 python=3 anaconda ipykernel tensorflow -y
RUN /bin/bash -c "source activate py3 && conda install pip -y"
RUN /bin/bash -c "source activate py3 && conda update pip"
RUN /bin/bash -c "source activate py3 && conda install jupyter notebook numpy scipy scikit-learn numexpr pandas pandas-datareader -y"

# Install kernels for jupyter
RUN /bin/bash -c "source activate py27 && ipython kernel install --user"
RUN /bin/bash -c "source activate py3 && ipython kernel install --user"


RUN mkdir /opt/notebooks
COPY ./jupyter.sh /root

EXPOSE 8888 

ENTRYPOINT /bin/bash /root/jupyter.sh 