
# The base image of the nginx wil be built using debian:slim version as its base
# This version is minimal, so that unnecessary packages are minimized to reduce size and complexity
FROM debian:bullseye

# Debian uses apt as its package manager so we will configure it in the RUN cmd
# update the package manager
# install NGINX and dependencies like openssl
# clean the cache files after install to reduce the image size
# no-install-recomends to install only necessary dependencies
RUN apt update

RUN apt install -y \
    nginx \
    openssl \
    && apt clean \ 
    && rm -rf /var/lib/apt/lists/*

# Generate self-signed SSL certificate
# Need to change this, right now it's tied to the image -> unsafe
# can try to mount it as a volume on runtime via Docker
RUN mkdir -p /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/self-signed.key \
    -out /etc/ssl/certs/self-signed.crt \
    -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42School/OU=Student/CN=localhost"


    
# Copy necessary files for NGINX image
COPY ./conf/nginx.conf /etc/nginx/sites-available/.
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

#COPY ./tools/default /etc/nginx/sites-available/.

#RUN mkdir -p /var/www/wordpress && chown -R www-data:www-data /var/www/wordpress


# Exposing ports we want NGINX to listen to
EXPOSE 443 

# NGINX must run in the foreground to keep the container alive
# The -g flag allows you to pass a global directive to NGINX.
# These directives override any default or configuration-file-specified behavior for NGINX
# This is a specific global directive for NGINX.
# By default, NGINX runs as a daemon, meaning it detaches from the terminal and runs as a background process.
# daemon off; tells NGINX not to run as a daemon, and instead stay in the foreground
CMD ["nginx", "-g", "daemon off;"]

#ENTRYPOINT ["nginx", "-g", "daemon off;"]
