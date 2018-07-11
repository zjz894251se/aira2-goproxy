#!/bin/sh
if [ $2 -eq 1 ]; then
	#mv "$3" /data
	mv "$3" ${$3%/*}
fi
echo [$(date)] $2, $3, $1 "<br>" >> /data/_log.html
