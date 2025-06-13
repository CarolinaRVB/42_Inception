FROM debian:bullseye

RUN apt update

RUN apt update && \
    apt install -y nginx openssl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create directories for SSL certs and generate self-signed certificate
RUN mkdir -p /etc/nginx/ssl/certs /etc/nginx/ssl/private

# Copy Nginx config files
COPY ./conf/nginx.conf /etc/nginx/conf.d
#RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# Expose HTTPS port
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]