FROM continuumio/miniconda3

# Port
ENV PORT=8888

WORKDIR /root 
RUN apt-get update -y
RUN apt-get install wget libgomp1 libgl1-mesa-glx -y

# Install miniconda
RUN conda update -n root conda -y --quiet

# Create python2.7 environment and install packages. python 2.7 will not have tensorflow-gpu since the graphlab environment requires anaconda 4.0.0 which conflicts with tensorflow-gpu
RUN conda create -n py27 python=2.7 anaconda=4.0.0 ipykernel -y
RUN /bin/bash -c "source activate py27 && conda install pip -y"
RUN /bin/bash -c "source activate py27 && conda update pip"
RUN /bin/bash -c "source activate py27 && pip install --upgrade --no-cache-dir https://get.graphlab.com/GraphLab-Create/2.1/kravivar@adobe.co/A0EA-7DD0-6DE1-3B84-40A9-1D42-19CB-2FEC/GraphLab-Create-License.tar.gz"
RUN /bin/bash -c "source activate py27 && conda install ipython-notebook nomkl numpy scipy scikit-learn numexpr pandas pandas-datareader -y"
RUN /bin/bash -c "source activate py27 && conda remove mkl mkl-service -y"

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