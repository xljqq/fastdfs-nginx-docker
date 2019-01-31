#!/bin/bash
#set -e

mkdir -p ${FASTDFS_BASE_PATH}

FASTDFS_LOG_FILE="${FASTDFS_BASE_PATH}/logs/${FASTDFS_MODE}d.log"
PID_NUMBER="${FASTDFS_BASE_PATH}/data/fdfs_${FASTDFS_MODE}d.pid"

echo "尝试启动 $FASTDFS_MODE 节点..."
if [ -f "$FASTDFS_LOG_FILE" ]; then 
	rm "$FASTDFS_LOG_FILE"
fi
# start the fastdfs node.	
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

if [ "$FASTDFS_MODE" == "storage"  ] ; then  
	/usr/local/nginx/sbin/nginx
fi

# wait for pid file(important!),the max start time is 5 seconds,if the pid number does not appear in 5 seconds,start failed.
TIMES=5
while [ ! -f "$PID_NUMBER" -a $TIMES -gt 0 ]
do
    sleep 1s
    TIMES=`expr $TIMES - 1`
done
tail -f "$FASTDFS_LOG_FILE"
