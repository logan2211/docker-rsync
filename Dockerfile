FROM debian:latest

ARG RSYNC_PACKAGE=rsync

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

RUN apt-get update && \
    apt-get install -y "${RSYNC_PACKAGE}" && \
    rm -rf /var/lib/apt/lists/* && \
    echo '&include /etc/rsync.d' > /etc/rsync.conf && \
    mkdir /etc/rsync.d

ENV RSYNC_CONFIG=/etc/rsync.conf

CMD ["rsync", \
     "--daemon", \
     "--no_detach", \
     "--log-file=/dev/stdout" \
     "--config=${RSYNC_CONFIG}"]
