FROM alpine:edge

RUN apk add --no-cache \
		ca-certificates \
		gcc \
		gettext \
		make \
		musl-dev \
		openssl-dev \
        binutils \
        file \
        gmp \
        isl \
        libatomic \
        libgcc \
        libgomp \
        libintl \
        libmagic \
        libunistring \
        libxml2 \
        mpc1 \
        mpfr3 \
        ncurses-libs \
        ncurses-terminfo \
        ncurses-terminfo-base \
        openssl \
        pkgconf \
        zlib-dev

WORKDIR /tmp
RUN wget https://www.stunnel.org/downloads/stunnel-5.46.tar.gz \
 && tar -zxvf stunnel-5.46.tar.gz

WORKDIR /tmp/stunnel-5.46
RUN ./configure \
 && make \
 && cp src/stunnel /usr/local/bin/stunnel

WORKDIR /

RUN rm -rf /tmp/stunnel-5.46
RUN apk del \
		gcc \
		make \
		musl-dev \
		openssl-dev \
        binutils \
        file \
        gmp \
        isl \
        libatomic \
        libgcc \
        libgomp \
        libintl \
        libmagic \
        libunistring \
        libxml2 \
        mpc1 \
        mpfr3 \
        ncurses-libs \
        ncurses-terminfo \
        ncurses-terminfo-base \
        pkgconf \
        zlib-dev

RUN mkdir /etc/stunnel /var/run/stunnel \
 && chmod -R g+rw /etc/stunnel /var/run/stunnel

LABEL org.label-schema.name="bcit/openshift-stunnel" \
      org.label-schema.description="Stunnel on Alpine" \
      org.label-schema.url="https://github.com/itsbcit/openshift-stunnel/" \
      org.label-schema.vcs-url="https://github.com/itsbcit/openshift-stunnel/" \
      org.label-schema.schema-version="1.0"
