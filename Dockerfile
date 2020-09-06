FROM debian:buster-slim

RUN apt update &&
    apt install -y --no-install-recommends pgbouncer &&
    rm -rf /var/lib/apt/lists/* &&
    apt purge --auto-remove &&
    apt clean

ADD entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
