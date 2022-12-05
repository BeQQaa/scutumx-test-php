FROM php:8.1-fpm-bullseye

RUN apt-get update && apt-get install -y openssl git unzip libbz2-dev nginx

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chmod +x /usr/local/bin/composer

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install bz2
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli

RUN docker-php-ext-enable pdo
RUN docker-php-ext-enable pdo_mysql
RUN docker-php-ext-enable bcmath
RUN docker-php-ext-enable bz2

WORKDIR /var/www/html

RUN mkdir /var/cache/prod
RUN mkdir /var/sessions
RUN touch /var/log/fpm-php.log

RUN chown -R www-data:www-data /var/cache
RUN chown -R www-data:www-data /var/sessions
RUN chmod -R 777 /var/cache
RUN chmod -R 777 /var/log
RUN chmod -R 777 /var/sessions

COPY docker/config/test-app.conf /etc/nginx/conf.d/default.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
