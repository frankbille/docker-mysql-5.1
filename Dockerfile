FROM centos:7
MAINTAINER "Frank Bille" <docker@frankbille.dk>
ENV container docker
LABEL name="MySQL Server" \
      version="5.1.73-build1" \
      description="MySQL Server with plugin version of InnoDB" \
      vendor="Frank Bille" \
      license=""

RUN curl -SL "http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.73-linux-x86_64-glibc23.tar.gz" -o mysql.tar.gz && \
    mkdir /usr/local/mysql && \
    tar -xzf mysql.tar.gz -C /usr/local/mysql --strip-components=1 && \
    rm mysql.tar.gz* && \
    rm -rf /usr/local/mysql/mysql-test /usr/local/mysql/sql-bench && \
    rm -rf /usr/local/mysql/bin/*-debug /usr/local/mysql/bin/*_embedded && \
    groupadd -r mysql && useradd -r -g mysql mysql

ENV PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

COPY my.cnf /etc/my.cnf
RUN chmod a-w /etc/my.cnf

WORKDIR /usr/local/mysql

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]
