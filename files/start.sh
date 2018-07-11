#!/bin/sh
if [ -f /conf/start.sh ]; then
	sh /conf/start.sh
else
	if [ ! -f /conf/aria2.conf ]; then
		cp /conf-copy/aria2.conf /conf/aria2.conf
		if [ $SECRET ]; then
			echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
		fi
	fi
	if [ ! -f /conf/on-complete.sh ]; then
		cp /conf-copy/on-complete.sh /conf/on-complete.sh
	fi

	chmod +x /conf/on-complete.sh
	touch /conf/aria2.session

	darkhttpd /aria2-webui --port 80 &
	darkhttpd /data --port 8080 &
	aria2c --conf-path=/conf/aria2.conf
	
	if  [ $OPTS ] ;then
		/proxy ${OPTS}
	fi
fi
