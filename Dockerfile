FROM alpine:latest

ARG CONFIRM=‘true’
ARG MYSQL_PASS=‘password’

VOLUME [“/storage”]

EXPOSE 21 67 68 69 80 111 443 1110 2049 4045 

# Install prerequisites
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update 
RUN apk upgrade

RUN apk --no-cache add dhcp tftp-hpa nfs-utils ncftp openssl sudo php7 apache2 mariadb mysql  

# && \update-ca-certificates

#Change password on MYSQL root user
RUN if [“${CONFIRM}” = "true" ]; then mysqladmin -u root password “${MYSQL_PASS}”


#Create FOG Directory
RUN mkdir /fog

#Download and Install FOG
RUN git clone https://github.com/fogproject/fogproject.git fog/ && \
    cd /fog/bin && \
    git cd fog/ && \
    git pull && \
    cd bin/ && \
    sudo ./installfog.sh -y


#Enable services on Boot
RUN rc-update add dhcp && \
    rc-update add tftp && \
    rc-update add nfs && \
    rc-update add ftp && \
    rc-update add mariadb && \
    rc-update add mysql && \
    rc-update add php7
