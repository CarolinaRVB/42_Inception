FROM debian:bullseye

# Update and install required packages
RUN apt-get update && apt-get install -y \
    php7.4 php7.4-fpm php7.4-mysql \
    php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-xmlrpc \
    php7.4-soap php7.4-zip php7.4-intl curl mariadb-client \
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
