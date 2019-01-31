#!/bin/sh
source /etc/profile

if [ -n "${FASTDFS_TRACKER_SERVER_NUM}" ] ; then
   TRACKER_SERVER=""
   for ((i=1; i<=${FASTDFS_TRACKER_SERVER_NUM}; i ++))  
   do
     FASTDFS_TRACKER_SERVER=`eval echo '$FASTDFS_TRACKER_SERVER_'"${i}"`
     TRACKER_SERVER="${TRACKER_SERVER}\ntracker_server=${FASTDFS_TRACKER_SERVER}:22122"  
   done  
   sed -i "s|FASTDFS_STORAGE_TRACKER_SERVER|${TRACKER_SERVER}|g" /etc/fdfs/storage.conf.template
   sed -i "s|FASTDFS_STORAGE_TRACKER_SERVER|${TRACKER_SERVER}|g" /etc/fdfs/mod_fastdfs.conf.template
fi

ENV_FILES="/etc/fdfs/tracker.conf /etc/fdfs/storage.conf /etc/fdfs/mod_fastdfs.conf /usr/local/nginx/conf/nginx.conf"
for file in ${ENV_FILES};do
    envsubst '${FASTDFS_BASE_PATH} ${FASTDFS_GROUP_NAME} ${FASTDFS_BIND_ADDR} ${FASTDFS_STORAGE_PORT} ${FASTDFS_STORAGE_HTTP_PORT}' < ${file}.template  > ${file}
done
