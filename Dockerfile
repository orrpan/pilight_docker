FROM alpine:3.12
MAINTAINER orrpan
ARG gitbranch=master

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
        bsd-compat-headers \
        openssl

RUN git clone https://github.com/wiringX/wiringX.git
RUN git clone --depth 5 -b ${gitbranch} https://www.github.com/pilight/pilight.git

WORKDIR /build/wiringX
RUN sed -i 's/__time_t/time_t/g; s/__suseconds_t/suseconds_t/g' src/wiringx.c \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make --quiet \
 && make install
    
WORKDIR /build/pilight
RUN sed -i 's/__time_t/time_t/g; s/__suseconds_t/suseconds_t/g' libs/pilight/core/arp.c \
 && sed -i 's/#include <luajit-2.0/#include <luajit-2.1/g' libs/pilight/lua_c/lua.h \
 && ln -s /usr/lib/liblua.so /usr/lib/liblua5.1.so \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make --quiet \
 && make install

WORKDIR /build/pilight_pem
RUN openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout pilight.key -out pilight.crt -subj "/CN=pilight.org" -days 3650 \
 && cat pilight.key pilight.crt > /etc/pilight/pilight.pem

WORKDIR /
RUN rm -rf /build
RUN apk --purge del \
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
        bsd-compat-headers \
        openssl

RUN apk --update add \
        mbedtls \
        lua5.1-libs \
        luajit \
        libpcap


VOLUME /etc/pilight
EXPOSE 5001

CMD ["/usr/local/sbin/pilight-daemon", "--foreground", "--config", "/etc/pilight/config.json" ]

