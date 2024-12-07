FROM alpine:3.20.2

RUN apk update && apk add --no-cache \
    curl \
    openssh-client \
    openssl \
    tar

RUN curl -L https://github.com/portainer/portainer/releases/download/2.19.5/portainer-2.19.5-linux-amd64.tar.gz -o /tmp/portainer.tar.gz \
    && tar -xzf /tmp/portainer.tar.gz -C /tmp \
    && mv /tmp/portainer/portainer /usr/local/bin/portainer \
    && rm -rf /tmp/portainer /tmp/portainer.tar.gz

RUN mkdir -p /data

EXPOSE 9000

CMD ["/usr/local/bin/portainer", "--bind=:9000", "--data", "/data"]