FROM golang:1.19.0-buster AS builder

WORKDIR /go/src/app

ADD . .

# Latest info on static builds: https://www.arp242.net/static-go.html @ 01/05/2020
RUN CGO_ENABLED=0 go build

FROM alpine:3.16.2

RUN apk add --no-cache postfix ca-certificates && \
	postconf maillog_file=/dev/stdout \
	         always_add_missing_headers=yes \
	         mynetworks="10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8" \
	         mydestination= \
	         default_transport="mailgun" \
	         import_environment="$(postconf -dh import_environment) MG_API_KEY MG_DOMAIN MG_URL" \
	         export_environment="$(postconf -dh export_environment) MG_API_KEY MG_DOMAIN MG_URL" && \
	echo 'mailgun unix - n n - - pipe user=nobody argv=/usr/bin/mailgun-mta ${recipient}' >> /etc/postfix/master.cf && \
	newaliases

ADD entrypoint.sh /entrypoint.sh
ADD queue_size.sh /usr/bin/queue_size
COPY --from=builder /go/src/app/mailgun-mta /usr/bin/

CMD ["/entrypoint.sh"]
