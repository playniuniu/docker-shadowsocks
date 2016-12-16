FROM alpine:latest
MAINTAINER playniuniu@gmail.com

ENV SS_VERSION 2.5.6
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VERSION.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VERSION
ENV SS_DEPENDENCE pcre
ENV SS_BUILD curl make gcc libc-dev autoconf libtool linux-headers openssl-dev asciidoc xmlto pcre-dev
ENV SS_PORT 8388

RUN set -ex \
    && apk --no-cache --update add $SS_DEPENDENCE $SS_BUILD \
    && curl -sSL $SS_URL | tar -zxv \
    && cd $SS_DIR \
    && ./configure \
    && make install \
    && cd .. \
    && rm -rf $SS_DIR \
    && apk del --purge $SS_BUILD \
    && rm -r /var/cache/apk/*

EXPOSE $SS_PORT/tcp
EXPOSE $SS_PORT/udp

ENTRYPOINT ["ss-server", "-c", "/etc/shadowsocks.json"]
CMD ["--fast-open", "-u", "-d", "8.8.8.8"]
