FROM jupyter/base-notebook
MAINTAINER Nikolay Veldyaykin  "novel8mail@gmail.com"

USER root

WORKDIR /opt

RUN pip install -U numpy
RUN apt-get update
RUN apt-get install -y python-scipy
RUN pip install -U pymorphy2
RUN pip install -U pymystem3
RUN pip install -U nltk
RUN pip install -U gensim
RUN pip install -U sklearn
RUN pip install -U rake-nltk

EXPOSE 8888
WORKDIR $HOME

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

RUN wget http://download.cdn.yandex.net/tomita/tomita-linux64.bz2
RUN tar xvjf tomita-linux64.bz2
RUN rm tomita-linux64.bz2

