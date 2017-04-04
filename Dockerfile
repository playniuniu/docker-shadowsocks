FROM alpine:latest
MAINTAINER playniuniu@gmail.com

ENV SS_VERSION 3.0.5
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VERSION/shadowsocks-libev-$SS_VERSION.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VERSION
ENV SS_BUILD autoconf build-base curl libev-dev libtool linux-headers udns-dev libsodium-dev mbedtls-dev pcre-dev tar
ENV SS_PORT 8388

RUN set -ex \
    && apk add --no-cache --update $SS_BUILD \
    && curl -sSL $SS_URL | tar -zxv \
    && cd $SS_DIR \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && cd .. \
    && runDeps="$( \
       scanelf --needed --nobanner /usr/bin/ss-* \
       | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
       | xargs -r apk info --installed \
       | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && rm -rf $SS_DIR \
    && apk del --purge $SS_BUILD \
    && rm -r /var/cache/apk/*

EXPOSE $SS_PORT/tcp
EXPOSE $SS_PORT/udp

ENTRYPOINT ["ss-server", "-c", "/etc/shadowsocks.json"]
CMD ["--fast-open", "-u", "-d", "8.8.8.8"]
