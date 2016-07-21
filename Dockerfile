#FROM perl:latest
FROM ubuntu:latest
MAINTAINER nkmry <nkmry333@gmail.com>

WORKDIR /root

RUN apt-get update --fix-missing
RUN apt-get upgrade -y --fix-missing
#RUN apt-get install -y --fix-missing build-essential
RUN apt-get install -y --fix-missing wget
RUN apt-get install -y --fix-missing gcc
RUN apt-get install -y --fix-missing g++
RUN apt-get install -y --fix-missing make
# to decompress
RUN apt-get install -y --fix-missing bzip2
RUN apt-get install -y --fix-missing unzip

# to use Japanese
RUN apt-get install -y locales --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# install JUMAN
RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2 &&\ 
    tar xf juman-7.01.tar.bz2 &&\
    cd juman-7.01/ &&\ 
    ./configure && make && make install &&\
    cd .. &&\
    rm juman-7.01.tar.bz2 && rm -rf juman-7.01
RUN apt-get update && apt-get install -y --fix-missing libjuman4

# install KNP
RUN apt-get install -y --fix-missing zlib1g-dev
RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.16.tar.bz2 &&\
    tar xf knp-4.16.tar.bz2 &&\
    cd knp-4.16/ &&\
    ./configure && make && make install &&\
    cd .. &&\
    rm knp-4.16.tar.bz2 && rm -rf knp-4.16

# Miniconda3
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.0.5-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

# PyKNP for Python3
RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/pyknp-0.2.zip &&\
    unzip pyknp-0.2.zip &&\
    cd ku_nlp-pyknp-4a6106a8eb8b &&\
    wget http://www.trifields.jp/wp-content/uploads/2015/09/pyknp-0.1-python3.zip &&\
    unzip pyknp-0.1-python3.zip &&\
    patch -p1 < pyknp-0.1-python3.diff &&\
    python setup.py install &&\
    cd .. &&\
    rm -rf ku_nlp-pyknp-4a6106a8eb8b &&\
    rm pyknp-0.2.zip
RUN conda install six

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
