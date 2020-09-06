#! /bin/bash

pgb_conf="/etc/pgbouncer/pgbouncer.ini"

# header
cat <<EOF > "$pgb_conf"
;;; Autogenerated config using the base version of pgbouncer.ini to enable environment variable
;;; substitutions.
;;; see entrypoint.sh for the template
EOF

# content section was generated using this script
# sed -n '/^\[pgbouncer\]/,$p' pgbouncer.ini |
#     sed -r -e '/;unix_socket_dir/d'                                                 \
#         -e 's/^(logfile|listen_addr|listen_port)/;\1/'                              \
#         -e 's/\$/\\$/'                                                              \
#         -e 's/^([a-z_]+) *= *([^ ]*)$/\1 = ${PGB_\U\1\E:-\2}/'                      \
#         -e 's/^; *([a-z_]+) *= *(.*)$/;${PGB_\U\1\E:+\n}\1 = ${PGB_\U\1\E:-\2}/'
#
cat <<EOF >> "$pgb_conf"
[pgbouncer]

;;;
;;; Administrative settings
;;;

;${PGB_LOGFILE:+
}logfile = ${PGB_LOGFILE:-/var/log/postgresql/pgbouncer.log}
pidfile = ${PGB_PIDFILE:-/var/run/postgresql/pgbouncer.pid}

;;;
;;; Where to wait for clients
;;;

; IP address or * which means all IPs
;${PGB_LISTEN_ADDR:+
}listen_addr = ${PGB_LISTEN_ADDR:-127.0.0.1}
;${PGB_LISTEN_PORT:+
}listen_port = ${PGB_LISTEN_PORT:-6432}

; Unix socket is also used for -R.
; On Debian it should be /var/run/postgresql
;${PGB_UNIX_SOCKET_MODE:+
}unix_socket_mode = ${PGB_UNIX_SOCKET_MODE:-0777}
;${PGB_UNIX_SOCKET_GROUP:+
}unix_socket_group = ${PGB_UNIX_SOCKET_GROUP:-}
unix_socket_dir = ${PGB_UNIX_SOCKET_DIR:-/var/run/postgresql}

;;;
;;; TLS settings for accepting clients
;;;

;; disable, allow, require, verify-ca, verify-full
;${PGB_CLIENT_TLS_SSLMODE:+
}client_tls_sslmode = ${PGB_CLIENT_TLS_SSLMODE:-disable}

;; Path to file that contains trusted CA certs
;${PGB_CLIENT_TLS_CA_FILE:+
}client_tls_ca_file = ${PGB_CLIENT_TLS_CA_FILE:-<system default>}

;; Private key and cert to present to clients.
;; Required for accepting TLS connections from clients.
;${PGB_CLIENT_TLS_KEY_FILE:+
}client_tls_key_file = ${PGB_CLIENT_TLS_KEY_FILE:-}
;${PGB_CLIENT_TLS_CERT_FILE:+
}client_tls_cert_file = ${PGB_CLIENT_TLS_CERT_FILE:-}

;; fast, normal, secure, legacy, <ciphersuite string>
;${PGB_CLIENT_TLS_CIPHERS:+
}client_tls_ciphers = ${PGB_CLIENT_TLS_CIPHERS:-fast}

;; all, secure, tlsv1.0, tlsv1.1, tlsv1.2
;${PGB_CLIENT_TLS_PROTOCOLS:+
}client_tls_protocols = ${PGB_CLIENT_TLS_PROTOCOLS:-all}

;; none, auto, legacy
;${PGB_CLIENT_TLS_DHEPARAMS:+
}client_tls_dheparams = ${PGB_CLIENT_TLS_DHEPARAMS:-auto}

;; none, auto, <curve name>
;${PGB_CLIENT_TLS_ECDHCURVE:+
}client_tls_ecdhcurve = ${PGB_CLIENT_TLS_ECDHCURVE:-auto}

;;;
;;; TLS settings for connecting to backend databases
;;;

;; disable, allow, require, verify-ca, verify-full
;${PGB_SERVER_TLS_SSLMODE:+
}server_tls_sslmode = ${PGB_SERVER_TLS_SSLMODE:-disable}

;; Path to that contains trusted CA certs
;${PGB_SERVER_TLS_CA_FILE:+
}server_tls_ca_file = ${PGB_SERVER_TLS_CA_FILE:-<system default>}

;; Private key and cert to present to backend.
;; Needed only if backend server require client cert.
;${PGB_SERVER_TLS_KEY_FILE:+
}server_tls_key_file = ${PGB_SERVER_TLS_KEY_FILE:-}
;${PGB_SERVER_TLS_CERT_FILE:+
}server_tls_cert_file = ${PGB_SERVER_TLS_CERT_FILE:-}

;; all, secure, tlsv1.0, tlsv1.1, tlsv1.2
;${PGB_SERVER_TLS_PROTOCOLS:+
}server_tls_protocols = ${PGB_SERVER_TLS_PROTOCOLS:-all}

;; fast, normal, secure, legacy, <ciphersuite string>
;${PGB_SERVER_TLS_CIPHERS:+
}server_tls_ciphers = ${PGB_SERVER_TLS_CIPHERS:-fast}

;;;
;;; Authentication settings
;;;

; any, trust, plain, crypt, md5, cert, hba, pam
auth_type = ${PGB_AUTH_TYPE:-trust}
;${PGB_AUTH_FILE:+
}auth_file = ${PGB_AUTH_FILE:-/8.0/main/global/pg_auth}
auth_file = ${PGB_AUTH_FILE:-/etc/pgbouncer/userlist.txt}

;; Path to HBA-style auth config
;${PGB_AUTH_HBA_FILE:+
}auth_hba_file = ${PGB_AUTH_HBA_FILE:-}

;; Query to use to fetch password from database.  Result
;; must have 2 columns - username and password hash.
;${PGB_AUTH_QUERY:+
}auth_query = ${PGB_AUTH_QUERY:-SELECT usename, passwd FROM pg_shadow WHERE usename=\$1}

;;;
;;; Users allowed into database 'pgbouncer'
;;;

; comma-separated list of users, who are allowed to change settings
;${PGB_ADMIN_USERS:+
}admin_users = ${PGB_ADMIN_USERS:-user2, someadmin, otheradmin}

; comma-separated list of users who are just allowed to use SHOW command
;${PGB_STATS_USERS:+
}stats_users = ${PGB_STATS_USERS:-stats, root}

;;;
;;; Pooler personality questions
;;;

; When server connection is released back to pool:
;   session      - after client disconnects
;   transaction  - after transaction finishes
;   statement    - after statement finishes
pool_mode = ${PGB_POOL_MODE:-session}

;
; Query for cleaning connection immediately after releasing from client.
; No need to put ROLLBACK here, pgbouncer does not reuse connections
; where transaction is left open.
;
; Query for 8.3+:
;   DISCARD ALL;
;
; Older versions:
;   RESET ALL; SET SESSION AUTHORIZATION DEFAULT
;
; Empty if transaction pooling is in use.
;
server_reset_query = DISCARD ALL


; Whether server_reset_query should run in all pooling modes.
; If it is off, server_reset_query is used only for session-pooling.
;${PGB_SERVER_RESET_QUERY_ALWAYS:+
}server_reset_query_always = ${PGB_SERVER_RESET_QUERY_ALWAYS:-0}

;
; Comma-separated list of parameters to ignore when given
; in startup packet.  Newer JDBC versions require the
; extra_float_digits here.
;
;${PGB_IGNORE_STARTUP_PARAMETERS:+
}ignore_startup_parameters = ${PGB_IGNORE_STARTUP_PARAMETERS:-extra_float_digits}

;
; When taking idle server into use, this query is ran first.
;   SELECT 1
;
;${PGB_SERVER_CHECK_QUERY:+
}server_check_query = ${PGB_SERVER_CHECK_QUERY:-select 1}

; If server was used more recently that this many seconds ago,
; skip the check query.  Value 0 may or may not run in immediately.
;${PGB_SERVER_CHECK_DELAY:+
}server_check_delay = ${PGB_SERVER_CHECK_DELAY:-30}

; Close servers in session pooling mode after a RECONNECT, RELOAD,
; etc. when they are idle instead of at the end of the session.
;${PGB_SERVER_FAST_CLOSE:+
}server_fast_close = ${PGB_SERVER_FAST_CLOSE:-0}

;; Use <appname - host> as application_name on server.
;${PGB_APPLICATION_NAME_ADD_HOST:+
}application_name_add_host = ${PGB_APPLICATION_NAME_ADD_HOST:-0}

;;;
;;; Connection limits
;;;

; total number of clients that can connect
max_client_conn = ${PGB_MAX_CLIENT_CONN:-100}

; default pool size.  20 is good number when transaction pooling
; is in use, in session pooling it needs to be the number of
; max clients you want to handle at any moment
default_pool_size = ${PGB_DEFAULT_POOL_SIZE:-20}

;; Minimum number of server connections to keep in pool.
;${PGB_MIN_POOL_SIZE:+
}min_pool_size = ${PGB_MIN_POOL_SIZE:-0}

; how many additional connection to allow in case of trouble
;${PGB_RESERVE_POOL_SIZE:+
}reserve_pool_size = ${PGB_RESERVE_POOL_SIZE:-0}

; if a clients needs to wait more than this many seconds, use reserve pool
;${PGB_RESERVE_POOL_TIMEOUT:+
}reserve_pool_timeout = ${PGB_RESERVE_POOL_TIMEOUT:-5}

; how many total connections to a single database to allow from all pools
;${PGB_MAX_DB_CONNECTIONS:+
}max_db_connections = ${PGB_MAX_DB_CONNECTIONS:-0}
;${PGB_MAX_USER_CONNECTIONS:+
}max_user_connections = ${PGB_MAX_USER_CONNECTIONS:-0}

; If off, then server connections are reused in LIFO manner
;${PGB_SERVER_ROUND_ROBIN:+
}server_round_robin = ${PGB_SERVER_ROUND_ROBIN:-0}

;;;
;;; Logging
;;;

;; Syslog settings
;${PGB_SYSLOG:+
}syslog = ${PGB_SYSLOG:-0}
;${PGB_SYSLOG_FACILITY:+
}syslog_facility = ${PGB_SYSLOG_FACILITY:-daemon}
;${PGB_SYSLOG_IDENT:+
}syslog_ident = ${PGB_SYSLOG_IDENT:-pgbouncer}

; log if client connects or server connection is made
;${PGB_LOG_CONNECTIONS:+
}log_connections = ${PGB_LOG_CONNECTIONS:-1}

; log if and why connection was closed
;${PGB_LOG_DISCONNECTIONS:+
}log_disconnections = ${PGB_LOG_DISCONNECTIONS:-1}

; log error messages pooler sends to clients
;${PGB_LOG_POOLER_ERRORS:+
}log_pooler_errors = ${PGB_LOG_POOLER_ERRORS:-1}

;; Period for writing aggregated stats into log.
;${PGB_STATS_PERIOD:+
}stats_period = ${PGB_STATS_PERIOD:-60}

;; Logging verbosity.  Same as -v switch on command line.
;${PGB_VERBOSE:+
}verbose = ${PGB_VERBOSE:-0}

;;;
;;; Timeouts
;;;

;; Close server connection if its been connected longer.
;${PGB_SERVER_LIFETIME:+
}server_lifetime = ${PGB_SERVER_LIFETIME:-3600}

;; Close server connection if its not been used in this time.
;; Allows to clean unnecessary connections from pool after peak.
;${PGB_SERVER_IDLE_TIMEOUT:+
}server_idle_timeout = ${PGB_SERVER_IDLE_TIMEOUT:-600}

;; Cancel connection attempt if server does not answer takes longer.
;${PGB_SERVER_CONNECT_TIMEOUT:+
}server_connect_timeout = ${PGB_SERVER_CONNECT_TIMEOUT:-15}

;; If server login failed (server_connect_timeout or auth failure)
;; then wait this many second.
;${PGB_SERVER_LOGIN_RETRY:+
}server_login_retry = ${PGB_SERVER_LOGIN_RETRY:-15}

;; Dangerous.  Server connection is closed if query does not return
;; in this time.  Should be used to survive network problems,
;; _not_ as statement_timeout. (default: 0)
;${PGB_QUERY_TIMEOUT:+
}query_timeout = ${PGB_QUERY_TIMEOUT:-0}

;; Dangerous.  Client connection is closed if the query is not assigned
;; to a server in this time.  Should be used to limit the number of queued
;; queries in case of a database or network failure. (default: 120)
;${PGB_QUERY_WAIT_TIMEOUT:+
}query_wait_timeout = ${PGB_QUERY_WAIT_TIMEOUT:-120}

;; Dangerous.  Client connection is closed if no activity in this time.
;; Should be used to survive network problems. (default: 0)
;${PGB_CLIENT_IDLE_TIMEOUT:+
}client_idle_timeout = ${PGB_CLIENT_IDLE_TIMEOUT:-0}

;; Disconnect clients who have not managed to log in after connecting
;; in this many seconds.
;${PGB_CLIENT_LOGIN_TIMEOUT:+
}client_login_timeout = ${PGB_CLIENT_LOGIN_TIMEOUT:-60}

;; Clean automatically created database entries (via "*") if they
;; stay unused in this many seconds.
;${PGB_AUTODB_IDLE_TIMEOUT:+
}autodb_idle_timeout = ${PGB_AUTODB_IDLE_TIMEOUT:-3600}

;; How long SUSPEND/-R waits for buffer flush before closing connection.
;${PGB_SUSPEND_TIMEOUT:+
}suspend_timeout = ${PGB_SUSPEND_TIMEOUT:-10}

;; Close connections which are in "IDLE in transaction" state longer than
;; this many seconds.
;${PGB_IDLE_TRANSACTION_TIMEOUT:+
}idle_transaction_timeout = ${PGB_IDLE_TRANSACTION_TIMEOUT:-0}

;;;
;;; Low-level tuning options
;;;

;; buffer for streaming packets
;${PGB_PKT_BUF:+
}pkt_buf = ${PGB_PKT_BUF:-4096}

;; man 2 listen
;${PGB_LISTEN_BACKLOG:+
}listen_backlog = ${PGB_LISTEN_BACKLOG:-128}

;; Max number pkt_buf to process in one event loop.
;${PGB_SBUF_LOOPCNT:+
}sbuf_loopcnt = ${PGB_SBUF_LOOPCNT:-5}

;; Maximum PostgreSQL protocol packet size.
;${PGB_MAX_PACKET_SIZE:+
}max_packet_size = ${PGB_MAX_PACKET_SIZE:-2147483647}

;; networking options, for info: man 7 tcp

;; Linux: notify program about new connection only if there
;; is also data received.  (Seconds to wait.)
;; On Linux the default is 45, on other OS'es 0.
;${PGB_TCP_DEFER_ACCEPT:+
}tcp_defer_accept = ${PGB_TCP_DEFER_ACCEPT:-0}

;; In-kernel buffer size (Linux default: 4096)
;${PGB_TCP_SOCKET_BUFFER:+
}tcp_socket_buffer = ${PGB_TCP_SOCKET_BUFFER:-0}

;; whether tcp keepalive should be turned on (0/1)
;${PGB_TCP_KEEPALIVE:+
}tcp_keepalive = ${PGB_TCP_KEEPALIVE:-1}

;; The following options are Linux-specific.
;; They also require tcp_keepalive=1.

;; count of keepalive packets
;${PGB_TCP_KEEPCNT:+
}tcp_keepcnt = ${PGB_TCP_KEEPCNT:-0}

;; how long the connection can be idle,
;; before sending keepalive packets
;${PGB_TCP_KEEPIDLE:+
}tcp_keepidle = ${PGB_TCP_KEEPIDLE:-0}

;; The time between individual keepalive probes.
;${PGB_TCP_KEEPINTVL:+
}tcp_keepintvl = ${PGB_TCP_KEEPINTVL:-0}

;; DNS lookup caching time
;${PGB_DNS_MAX_TTL:+
}dns_max_ttl = ${PGB_DNS_MAX_TTL:-15}

;; DNS zone SOA lookup period
;${PGB_DNS_ZONE_CHECK_PERIOD:+
}dns_zone_check_period = ${PGB_DNS_ZONE_CHECK_PERIOD:-0}

;; DNS negative result caching time
;${PGB_DNS_NXDOMAIN_TTL:+
}dns_nxdomain_ttl = ${PGB_DNS_NXDOMAIN_TTL:-15}

;;;
;;; Random stuff
;;;

;; Hackish security feature.  Helps against SQL-injection - when PQexec is disabled,
;; multi-statement cannot be made.
;${PGB_DISABLE_PQEXEC:+
}disable_pqexec = ${PGB_DISABLE_PQEXEC:-0}

;; Config file to use for next RELOAD/SIGHUP.
;; By default contains config file from command line.
;conffile

;; Win32 service name to register as.  job_name is alias for service_name,
;; used by some Skytools scripts.
;${PGB_SERVICE_NAME:+
}service_name = ${PGB_SERVICE_NAME:-pgbouncer}
;${PGB_JOB_NAME:+
}job_name = ${PGB_JOB_NAME:-pgbouncer}

;; Read additional config from the /etc/pgbouncer/pgbouncer-other.ini file
;%include /etc/pgbouncer/pgbouncer-other.ini
EOF

# footer
cat <<EOF >> "$pgb_conf"

;; Include all db config files
;; $ cat /etc/pgbouncer/databases/somedb.ini
;; [databases]
;; somedb = dbname=somedb host=somehost port=5432 user=someuser password=somepassword
EOF

# include all mounted db configs
find /etc/pgbouncer/databases -type f | xargs -r -L1 echo "%include" >> "$pgb_conf"

exec pgbouncer "$pgb_conf"
