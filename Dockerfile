FROM stealthizer/rpi-alpine-base:latest
MAINTAINER stealthizer - https://github.com/stealthizer

RUN apk --update add php5 php5-mysql php5-apache2 curl php5-cli php5-json php5-phar php5-openssl && rm -f /var/cache/apk/*
RUN curl -sS https://getcomposer.org/installer | php5 -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir /app && chown -R apache:apache /app && cd /app && ln -s /usr/lib/apache2 modules && ln -s /usr/lib/apache2 modules && \
ln -s /var/log/apache2 logs && mkdir -p /run/apache2 && ln -s /run/apache2 run && \
sed -i 's#^DocumentRoot ".*#DocumentRoot "/app"#g' /etc/apache2/httpd.conf && \
sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
sed -i 's#^ServerRoot.*#ServerRoot "/app"#g' /etc/apache2/httpd.conf && \
sed -i 's#^<Directory "/var/www/localhost/htdocs">.*#<Directory "/app">#g' /etc/apache2/httpd.conf && \
echo "Success"

ADD scripts/run.sh /scripts/run.sh
ADD app/index.php /app/index.php
RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
chmod -R 755 /scripts

EXPOSE 80

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]
