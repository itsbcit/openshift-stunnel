FROM bcit.io/alpine:3.13
LABEL maintainer="jesse_weisner@bcit.ca"
LABEL stunnel_version="5.57"
LABEL org.label-schema.name="bcit.io/openshift-stunnel"
LABEL org.label-schema.description="Stunnel on Alpine"
LABEL org.label-schema.url="https://github.com/itsbcit/openshift-stunnel/"
LABEL org.label-schema.vcs-url="https://github.com/itsbcit/openshift-stunnel/"
LABEL org.label-schema.schema-version="1.0"
LABEL build_id="1621542150"

RUN apk add --no-cache \
        ca-certificates \
        gettext \
        stunnel

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

CMD [ "sh", "-c", "/usr/bin/stunnel $STUNNEL_CONF" ]
