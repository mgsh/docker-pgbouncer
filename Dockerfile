FROM debian:buster-slim

RUN apt-get update &&                                       \
    apt-get install -y --no-install-recommends pgbouncer && \
    rm -rf /var/lib/apt/lists/* &&                          \
    apt-get purge -y --auto-remove &&                       \
    apt-get clean

ADD entrypoint.sh .

USER postgres

ENTRYPOINT ["./entrypoint.sh"]
