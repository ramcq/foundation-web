FROM centos/httpd-24-centos7 

USER root 

ENV SITE_ROOT=/opt/app-root/src \
    REPO=https://gitlab.gnome.org/Infrastructure/foundation-web.git

COPY app_data ${SITE_ROOT}
RUN mkdir ${SITE_ROOT}/html ${SITE_ROOT}/src && \
    yum install git automake -y && \
    yum install rh-php71-php rh-php71-php-cli rh-php71-php-common rh-php71-php-mysqlnd -y && \
    git clone ${REPO} ${SITE_ROOT}/src && \
    cd ${SITE_ROOT}/src && \
    ./autogen.sh --prefix=${SITE_ROOT}/html && make && make install && \
    chown -R 1000470000:1000470000 /opt/app-root/src

EXPOSE 8080

USER 1001
ENTRYPOINT ["/usr/bin/run-httpd"]
