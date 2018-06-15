export STUNNEL_CAFILE="${STUNNEL_CAFILE:-/etc/ssl/certs/ca-certificates.crt}"
export STUNNEL_CLIENT="${STUNNEL_CLIENT:-no}"
export STUNNEL_CONF="${STUNNEL_CONF:-/etc/stunnel/stunnel.conf}"
export STUNNEL_CONF_TEMPLATE="${STUNNEL_CONF_TEMPLATE:-/etc/stunnel/stunnel.conf.template}"
export STUNNEL_CRT="${STUNNEL_CRT:-/etc/stunnel/stunnel.pem}"
export STUNNEL_DEBUG="${STUNNEL_DEBUG:-5}"
export STUNNEL_KEY="${STUNNEL_KEY:-/etc/stunnel/stunnel.key}"
export STUNNEL_VERIFY_CHAIN="${STUNNEL_VERIFY_CHAIN:-no}"

if [[ -z "${STUNNEL_SERVICE}" ]] || [[ -z "${STUNNEL_ACCEPT}" ]] || [[ -z "${STUNNEL_CONNECT}" ]]; then
    echo >&2 "one or more STUNNEL_SERVICE* values missing: "
    echo >&2 "  STUNNEL_SERVICE=${STUNNEL_SERVICE}"
    echo >&2 "  STUNNEL_ACCEPT=${STUNNEL_ACCEPT}"
    echo >&2 "  STUNNEL_CONNECT=${STUNNEL_CONNECT}"
    exit 1
fi

if [[ ! -f ${STUNNEL_KEY} ]]; then
    if [[ -f ${STUNNEL_CRT} ]]; then
        echo >&2 "crt (${STUNNEL_CRT}) missing key (${STUNNEL_KEY})"
        exit 1
    fi

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${STUNNEL_KEY} -out ${STUNNEL_CRT} \
        -config /etc/stunnel/openssl.cnf
fi

cp -v ${STUNNEL_CAFILE} /usr/local/share/ca-certificates/stunnel-ca.crt
cp -v ${STUNNEL_CRT} /usr/local/share/ca-certificates/stunnel.crt
update-ca-certificates

if [[ ! -s ${STUNNEL_CONF} ]]; then
    cat /etc/stunnel/stunnel.conf.template | envsubst > ${STUNNEL_CONF}
fi
