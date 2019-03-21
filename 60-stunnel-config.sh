if [[ -z "${STUNNEL_SERVICE}" ]] || [[ -z "${STUNNEL_ACCEPT}" ]] || [[ -z "${STUNNEL_CONNECT}" ]]; then
    echo >&2 "one or more STUNNEL_* values missing: "
    echo >&2 "  STUNNEL_SERVICE=${STUNNEL_SERVICE}"
    echo >&2 "  STUNNEL_ACCEPT=${STUNNEL_ACCEPT}"
    echo >&2 "  STUNNEL_CONNECT=${STUNNEL_CONNECT}"
    exit 1
fi

if [[ "${STUNNEL_VERIFY_CHAIN}" != "no" ]] && [[ ! -f ${STUNNEL_CACERT} ]]; then
    echo >&2 "CA cert \"${STUNNEL_CACERT}\" not found. Disabling verification."
    export STUNNEL_VERIFY_CHAIN='no'
fi

if [[ "${STUNNEL_VERIFY_CHAIN}" != "no" ]];then
    if [[ ! -r ${STUNNEL_KEY} ]] || [[ ! -r ${STUNNEL_CERT} ]]; then
        echo >&2 "Cert ${STUNNEL_CERT} or key ${STUNNEL_KEY} missing. Generating new pair."
        rm -f ${STUNNEL_KEY} ${STUNNEL_CERT}
        openssl req -x509 -nodes -rand ${RANDOM_SOURCE} -days 365 -newkey rsa:2048 \
        -keyout ${STUNNEL_KEY} -out ${STUNNEL_CERT} \
        -config /etc/stunnel/openssl.cnf
    fi
fi

export STUNNEL_VERIFY_CHAIN

cat /etc/stunnel/stunnel.conf.template | envsubst > ${STUNNEL_CONF}
