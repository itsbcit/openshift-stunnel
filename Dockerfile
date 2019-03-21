FROM bcit/alpine

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
RUN wget https://www.stunnel.org/downloads/stunnel-5.50.tar.gz \
 && tar -zxvf stunnel-5.50.tar.gz

WORKDIR /tmp/stunnel-5.50
RUN ./configure \
 && make \
 && cp src/stunnel /usr/local/bin/stunnel

WORKDIR /

RUN rm -rf /tmp/stunnel-5.50
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

RUN mkdir \
    /etc/stunnel \
    /var/run/stunnel \
    /var/log/stunnel \
 && chmod -R g+rw \
    /etc/stunnel \
    /var/run/stunnel \
    /var/log/stunnel \
    /usr/local/share/ca-certificates \
    /etc/ssl

COPY 60-stunnel-config.sh /docker-entrypoint.d/
COPY openssl.cnf /etc/stunnel/
COPY stunnel.conf.template /etc/stunnel/

ENV STUNNEL_CACERT "/etc/stunnel/stunnel-ca.crt"
ENV STUNNEL_CLIENT no
ENV STUNNEL_CONF /etc/stunnel/stunnel.conf
ENV STUNNEL_CONF_TEMPLATE /etc/stunnel/stunnel.conf.template
ENV STUNNEL_CERT /etc/stunnel/stunnel.pem
ENV STUNNEL_DEBUG 6
ENV STUNNEL_KEY  /etc/stunnel/stunnel.key
ENV STUNNEL_VERIFY_CHAIN no
ENV RANDOM_SOURCE /dev/urandom

LABEL org.label-schema.name="bcit/openshift-stunnel" \
      org.label-schema.description="Stunnel on Alpine" \
      org.label-schema.url="https://github.com/itsbcit/openshift-stunnel/" \
      org.label-schema.vcs-url="https://github.com/itsbcit/openshift-stunnel/" \
      org.label-schema.schema-version="1.0"

CMD [ "sh", "-c", "/usr/local/bin/stunnel $STUNNEL_CONF" ]
