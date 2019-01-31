FROM centos

ENV FASTDFS_TRACKER_SERVER_NUM 1

ENV FASTDFS_GROUP_NAME group1

ENV FASTDFS_BASE_PATH  /fastdfs/storage

ENV FASTDFS_STORAGE_PORT 23000

ENV FASTDFS_STORAGE_HTTP_PORT 8888

ADD fastdfs /usr/local/src/fastdfs

ADD fastdfs-nginx-module /usr/local/src/fastdfs-nginx-module

ADD libfastcommon /usr/local/src/libfastcommon

ADD LuaJIT-2.0.5.tar.gz /usr/local/src

ADD lua-nginx-module-0.10.14rc3.tar.gz /usr/local/src

ADD nginx-1.15.8.tar.gz /usr/local/src

ADD ngx_cache_purge-2.3.tar.gz /usr/local/src

ADD ngx_devel_kit-0.3.1rc1.tar.gz /usr/local/src

RUN yum install -y gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl openssl-devel \
    libpng libjpeg libpng-devel libjpeg-devel ghostscript libtiff libtiff-devel freetype freetype-devel  \
	ImageMagick ImageMagick-devel gd-devel

RUN mkdir -p /fastdfs/tracker && \
    mkdir -p /fastdfs/storage && \
	cd /usr/local/src/libfastcommon/ && \
	./make.sh && \
	./make.sh install && \
	cd /usr/local/src/fastdfs/ && \
	./make.sh && \
	./make.sh install && \
	cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf && \
	cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf && \
	cp /usr/local/src/fastdfs/conf/http.conf /etc/fdfs/ && \
	cp /usr/local/src/fastdfs/conf/mime.types /etc/fdfs/ && \
	cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs && \
	cd /usr/local/src/LuaJIT-2.0.5 && \
    make && \
    make install && \
	cd /usr/local/src/nginx-1.15.8/ && \
	./configure  \
    --prefix=/usr/local/nginx \
    --pid-path=/var/local/nginx/nginx.pid  \
    --lock-path=/var/lock/nginx/nginx.lock  \
    --error-log-path=/usr/local/nginx/logs/error.log  \
    --http-log-path=/usr/local/nginx/logs/access.log  \
    --with-http_gzip_static_module  \
    --http-client-body-temp-path=/var/temp/nginx/client  \
    --http-proxy-temp-path=/var/temp/nginx/proxy  \
    --http-fastcgi-temp-path=/var/temp/nginx/fastcgi  \
    --http-uwsgi-temp-path=/var/temp/nginx/uwsgi  \
    --http-scgi-temp-path=/var/temp/nginx/scgi  \
    --with-http_gzip_static_module  \
    --with-http_stub_status_module  \
    --with-http_gunzip_module  \
    --with-poll_module  \
    --with-threads  \
	--with-http_realip_module  \
	--with-stream  \
	--with-http_ssl_module  \
	--with-http_image_filter_module=dynamic  \
	--add-module=/usr/local/src/ngx_devel_kit-0.3.1rc1/  \
	--add-module=/usr/local/src/lua-nginx-module-0.10.14rc3/  \
    --add-module=/usr/local/src/fastdfs-nginx-module/src  \
    --add-module=/usr/local/src/ngx_cache_purge-2.3 && \
	make && \
	make install && \
       mkdir -p /var/temp/nginx/client && \
       echo "/usr/local/lib" >> /etc/ld.so.conf && \
       ldconfig && \
        yum remove -y make && \
    yum clean all && \
    rm -rf /usr/local/src/* 


COPY conf/tracker.conf.template /etc/fdfs/tracker.conf.template

COPY conf/storage.conf.template /etc/fdfs/storage.conf.template

COPY conf/mod_fastdfs.conf.template /etc/fdfs/mod_fastdfs.conf.template

COPY conf/nginx.conf.template /usr/local/nginx/conf/nginx.conf.template

COPY start.sh /start.sh

COPY envsubst.sh /envsubst.sh

RUN chmod 755 /start.sh

RUN chmod 755 /envsubst.sh

CMD ["sh","-c","/envsubst.sh && /start.sh"]

STOPSIGNAL SIGQUIT
