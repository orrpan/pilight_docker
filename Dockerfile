FROM alpine:3.12
MAINTAINER Oskar Joelsson

WORKDIR /build

RUN apk --update add \
        git \
        cmake \
        g++ \
        make \
        linux-headers \
        libpcap-dev \
        mbedtls-dev \
        lua5.1-dev \
        luajit-dev \
        libexecinfo-dev \
        bsd-compat-headers

RUN git clone https://github.com/wiringX/wiringX.git
RUN git clone --depth 5 -b master https://www.github.com/pilight/pilight.git

WORKDIR /build/wiringX
RUN sed -i 's/__time_t/time_t/g; s/__suseconds_t/suseconds_t/g' src/wiringx.c \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install
    
WORKDIR /build/pilight
RUN sed -i 's/__time_t/time_t/g; s/__suseconds_t/suseconds_t/g' libs/pilight/core/arp.c \
 && ln -s /usr/lib/liblua.so /usr/lib/liblua5.1.so \
 && sed -i 's/#include <luajit-2.0/#include <luajit-2.1/g' libs/pilight/lua_c/lua.h \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install

WORKDIR /

ENV HOME /etc/pilight/config
# RUN cd $HOME

# ENV AIRPLAY_NAME "Dockers"

# ENTRYPOINT [ "bash" ]

# ADD app /app
