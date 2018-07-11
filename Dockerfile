FROM golang:1.10.3-alpine as builder
MAINTAINER zjz894251se <zjz894251se@qq.com>
ARG GOPROXY_VERSION=master
RUN apk update && \
	apk upgrade && \
	apk add --update git && \
	cd /go/src/ && \
	git clone https://github.com/snail007/goproxy && \
	cd goproxy && \
	git checkout ${GOPROXY_VERSION} && \
	go get && \
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o proxy

FROM alpine:3.7

RUN apk add --update bash --update aria2 --update darkhttpd && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data

#	apk del git

ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf
ADD files/on-complete.sh /conf-copy/on-complete.sh
COPY --from=builder /go/src/goproxy/proxy /
RUN chmod +x /conf-copy/start.sh

WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]
EXPOSE 6800
EXPOSE 6888 
#goproxy
EXPOSE 33080
#RUN
CMD sh /conf-copy/start.sh && /proxy ${OPTS}
