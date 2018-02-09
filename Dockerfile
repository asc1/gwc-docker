FROM centos:7

RUN set -x && \
	yum install -y epel-release && \
	yum update -y && \
	yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel zip unzip curl && \
	yum -y clean all

ENV TOMCAT_HOME=/tomcat TINI_VERSION=v0.14.0

# TINI
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]


# TOMCAT
ADD http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15.tar.gz ${TOMCAT_HOME}/archive/
#COPY apache-tomcat-8.5.15.tar.gz ${TOMCAT_HOME}/archive/


RUN set -x && \
    groupadd -g 501 tomcat && \
    useradd -g tomcat -u 501 tomcat && \
    tar --strip-components=1 -xzf ${TOMCAT_HOME}/archive/apache-tomcat-*.tar.gz -C ${TOMCAT_HOME} && \
	chown -R tomcat:tomcat ${TOMCAT_HOME} && \
	rm -rf ${TOMCAT_HOME}/webapps/*


# GEOWEBCACHE
ENV GEOWEBCACHE_CACHE_DIR=/geowebcache JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

COPY ./geowebcache.war ${TOMCAT_HOME}/webapps/
COPY ./run.sh ${TOMCAT_HOME}/bin/run.sh
COPY ./ROOT ${TOMCAT_HOME}/webapps/ROOT
#COPY ./data/* ${GEOWEBCACHE_CACHE_DIR}/

RUN set -x && \
    mkdir -p ${GEOWEBCACHE_CACHE_DIR} && \
	chown -R tomcat:tomcat ${TOMCAT_HOME} ${GEOWEBCACHE_CACHE_DIR}

VOLUME ${GEOWEBCACHE_CACHE_DIR}

EXPOSE 8080

CMD [ "su", "-m", "-c", "${TOMCAT_HOME}/bin/run.sh", "tomcat"]
