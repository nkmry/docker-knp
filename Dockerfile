#FROM perl:latest
FROM ubuntu:latest
MAINTAINER nkmry <nkmry333@gmail.com>

WORKDIR /root

# to use Japanese
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Change DNS to Google Public DNS
RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null &&\
# Install depended packages
    apt-get update --fix-missing &&\
    apt-get upgrade -y --fix-missing &&\
    apt-get install -y wget gcc g++ make bzip2 cmake xz-utils cmake xz-utils zlib1g-dev &&\

# to use Japanese
    apt-get install -y locales --no-install-recommends &&\
    rm -rf /var/lib/apt/lists/* &&\
    locale-gen ja_JP.UTF-8 &&\

# install JUMAN++
    wget https://github.com/ku-nlp/jumanpp/releases/download/v2.0.0-rc2/jumanpp-2.0.0-rc2.tar.xz &&\
    tar xf jumanpp-2.0.0-rc2.tar.xz &&\
    cd jumanpp-2.0.0-rc2/ &&\ 
    mkdir bld &&\
    cd bld &&\
    cmake .. -DCMAKE_BUILD_TYPE=Release &&\
    make install &&\
    cd ../../ &&\
    rm -rf jumanpp-2.0.0-rc2.tar.xz jumanpp-2.0.0-rc2 &&\
# install KNP
    wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.19.tar.bz2 &&\
    tar xf knp-4.19.tar.bz2 &&\
    cd knp-4.19/ &&\
    ./configure && make && make install &&\
    cd .. &&\
    rm knp-4.19.tar.bz2 && rm -rf knp-4.19
