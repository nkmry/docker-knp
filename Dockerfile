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
# to decompress *.tar.bz2
RUN apt-get install -y --fix-missing bzip2

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
