FROM debian:bullseye

RUN apt update

RUN apt update && \
    apt install -y nginx openssl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create directories for SSL certs and generate self-signed certificate
RUN mkdir -p /etc/nginx/ssl/certs /etc/nginx/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/private/crebelo-.key \
    -out /etc/nginx/ssl/certs/crebelo-.crt \
    -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42School/OU=Student/CN=crebelo-.42.fr"

# Copy Nginx config files
COPY ./conf/nginx.conf /etc/nginx/conf.d
#RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# Expose HTTPS port
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]