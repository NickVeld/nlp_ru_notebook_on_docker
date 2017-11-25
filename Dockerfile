FROM jupyter/base-notebook
MAINTAINER Nikolay Veldyaykin  "novel8mail@gmail.com"

USER root

WORKDIR /opt

RUN pip install -U numpy
RUN apt-get update
RUN apt-get install -y python-numpy python-scipy
RUN pip install -U python-rake
RUN pip install -U pymorphy2
RUN pip install -U pymystem3
RUN pip install -U nltk
RUN pip install -U gensim
RUN pip install -U sklearn
RUN pip install -U rake-nltk
RUN pip install -U pandas
RUN pip install -U matplotlib
RUN pip install -U wordcloud
RUN pip install -U tqdm
RUN pip install -U wheel
RUN apt-get install -y git make cmake build-essential libboost-all-dev
RUN pip install -U protobuf

WORKDIR /home/$NB_USER

RUN git clone --branch=stable https://github.com/bigartm/bigartm.git
RUN mkdir ./bigartm/build
WORKDIR /home/$NB_USER/bigartm/build
RUN cmake -DPYTHON=python3 ..
RUN make

# Step 2 - install Python interface for BigARTM
#WORKDIR /home/$NB_USER/bigartm/python
#RUN ls
#RUN python setup.py install

RUN pip install python/bigartm*.whl

# Step 3 - point ARTM_SHARED_LIBRARY variable to libartm.so (libartm.dylib) location
RUN export ARTM_SHARED_LIBRARY=/home/$NB_USER/bigartm/build/src/artm/libartm.so

EXPOSE 8888
WORKDIR $HOME

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

#RUN wget http://download.cdn.yandex.net/tomita/tomita-linux64.bz2
#RUN bunzip2 tomita-linux64.bz2
#RUN rm tomita-linux64.bz2

#RUN git clone https://github.com/NickVeld/pytomita.git
#RUN pip install pytomita/pytomita

#RUN ls /opt/conda/lib/python3.6/site-packages
