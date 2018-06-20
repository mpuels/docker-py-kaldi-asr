FROM debian:8

ARG MAKE_JOBS=1

ARG DIR_PKGCONFIG=/usr/lib/pkgconfig

ENV LD_LIBRARY_PATH /opt/kaldi/tools/openfst/lib:/opt/kaldi/src/lib

RUN mkdir -p ${DIR_PKGCONFIG}
COPY kaldi-asr.pc ${DIR_PKGCONFIG}

RUN apt-get update && apt-get install --no-install-recommends -y  \
    autoconf \
    automake \
    bzip2 \
    g++ \
    git \
    libatlas3-base \
    libtool-bin \
    make \
    patch \
    python2.7 \
    python3 \
    python-pip \
    subversion \
    wget \
    zlib1g-dev && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y

WORKDIR /opt

RUN git clone https://github.com/kaldi-asr/kaldi && \
    cd /opt/kaldi/tools && \
    make -j${MAKE_JOBS} && \
    ./install_portaudio.sh && \
    cd /opt/kaldi/src && ./configure --shared && \
    sed -i '/-g # -O0 -DKALDI_PARANOID/c\-O3 -DNDEBUG' kaldi.mk && \
    make depend && make -j${MAKE_JOBS} && \
    cd /opt/kaldi/src/online && make depend && make -j${MAKE_JOBS} && \
    rm -rf /opt/kaldi/.git && \
    rm -rf /opt/kaldi/egs/ /opt/kaldi/windows/ /opt/kaldi/misc/ && \
    find /opt/kaldi/src/ \
         -type f \
         -not -name '*.h' \
         -not -name '*.so' \
         -delete && \
    find /opt/kaldi/tools/ \
         -type f \
         -not -name '*.h' \
         -not -name '*.so' \
         -not -name '*.so*' \
         -delete

RUN apt-get install --no-install-recommends -y \
            libatlas-base-dev \
            pkg-config \
            python-dev && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y

RUN pip install \
        cython==0.28.3 \
        numpy==1.14.4 \
        pathlib2==2.3.2 \
        plac==0.9.6 \
        python-json-logger==0.1.9 \
        setproctitle==1.1.10 \
        typing==3.6.4

RUN pip install py-kaldi-asr==0.3.1

COPY asr_server.py /opt/asr_server/
