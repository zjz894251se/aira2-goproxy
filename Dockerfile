FROM golang:1.10.3-alpine as builder
MAINTAINER zjz894251se <zjz894251se@qq.com>
ARG GOPROXY_VERSION=master
RUN apk update && \
	apk upgrade && \
	apk add --no-cache --update bash && \
	apk add --no-cache --update aria2 && \
	apk add git && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	cd /go/src/ && \
	git clone https://github.com/snail007/goproxy && \
	cd goproxy && \
	git checkout ${GOPROXY_VERSION} && \
	go get && \
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o proxy && \
	apk del git && \
	apk add --update darkhttpd

ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf
ADD files/on-complete.sh /conf-copy/on-complete.sh

RUN chmod +x /conf-copy/start.sh

FROM alpine:3.7
COPY --from=builder /go/src/goproxy/proxy /

WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]
EXPOSE 6800
EXPOSE 8080
#goproxy
EXPOSE 33080
#RUN
CMD ["/conf-copy/start.sh"]
