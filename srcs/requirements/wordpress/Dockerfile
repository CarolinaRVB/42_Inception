# FROM debian:bullseye

# RUN apt update

# RUN apt install -y \
#     php php-fpm php-mysql curl mariadb-client \
#     && apt clean \ 
#     && rm -rf /var/lib/apt/lists/*


# #github 
# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/.

# COPY ./tools/setup.sh /

# RUN mkdir -p /run/php
# RUN mkdir -p /var/www/wordpress


# RUN chmod +x /setup.sh
# #RUN ./setup.sh


# CMD ["/bin/bash", "-c", "/setup.sh && /usr/sbin/php-fpm7.4 -F"]

# #ENTRYPOINT ["/setup.sh"]
# #CMD ["/usr/sbin/php-fpm7.4", "-F"]

FROM debian:bullseye

# Update and install required packages
RUN apt-get update && apt-get install -y \
    php7.4 php7.4-fpm php7.4-mysql curl mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy configuration files
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY ./tools/setup.sh /setup.sh

# Ensure required directories exist
RUN mkdir -p /run/php /var/www/wordpress

# Make setup script executable
RUN chmod +x /setup.sh

ENTRYPOINT [ "/setup.sh" ]
# Run setup script and start PHP-FPM
CMD ["/usr/sbin/php-fpm7.4", "-F"]
