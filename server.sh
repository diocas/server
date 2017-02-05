#!/bin/bash
cd "${0%/*}"

: "${SERVER_ROOT?}"
: "${SERVER_URL?}"
: "${DEFAULT_PASS?}"

CNAME="server"

export SERVER_CONFIG_PATH="${SERVER_ROOT}/configs"
export SERVER_MEDIA_PATH="${SERVER_ROOT}/media"
export SERVER_DATA_PATH="${SERVER_ROOT}"
export SERVER_LOGS_PATH="/var/log"
export SERVER_DOWNLOADS_PATH="${SERVER_ROOT}/downloads"
export SERVER_CERTS_PATH="${SERVER_CONFIG_PATH}/certs"


cert_create ()
{
     sudo certbot certonly -a webroot --webroot-path=${SERVER_CONFIG_PATH}/nginx/static -d ${SERVER_URL}
     sudo cp -LRf /etc/letsencrypt/live/${SERVER_URL}/. $SERVER_CERTS_PATH
     docker restart nginx
}

cert_renew ()
{
     sudo certbot renew --quiet --no-self-upgrade
     sudo cp -LRf /etc/letsencrypt/live/${SERVER_URL}/. $SERVER_CERTS_PATH
     docker restart nginx
}


case $1 in
	start) docker-compose -p $CNAME start;;
	up) docker-compose -p $CNAME up -d;;
	stop) docker-compose -p $CNAME stop;;
	rm) docker-compose -p $CNAME rm;;
	down) docker-compose -p $CNAME down;;
	logs) docker-compose -p $CNAME logs;;
        cert-create) cert_create;;
        cert-test-renew) sudo certbot renew --dry-run;;
        cert-renew) cert_renew;;
	*) echo 'start | up | stop | rm | down | logs | cert-create | cert-test-renew | cert-renew';;
esac




