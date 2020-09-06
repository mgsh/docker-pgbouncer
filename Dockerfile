FROM debian:buster-slim

RUN apt-get update &&                           \
    apt-get install -y --no-install-recommends  \
      pgbouncer postgresql-client-11 &&         \
    rm -rf /var/lib/apt/lists/* &&              \
    apt-get purge -y --auto-remove &&           \
    apt-get clean

RUN mkdir /etc/pgbouncer/databases
RUN chown postgres:postgres /etc/pgbouncer/databases
ADD entrypoint.sh .

USER postgres
ENTRYPOINT ["./entrypoint.sh"]
