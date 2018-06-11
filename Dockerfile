FROM dweomer/stunnel

RUN chown -R 0:0 /etc/stunnel /usr/local/share/ca-certificates /etc/ssl \
                 /var/run/stunnel \
 && chmod -R g+rw /etc/stunnel /usr/local/share/ca-certificates /etc/ssl \
                  /var/run/stunnel

COPY *.template /srv/stunnel/
