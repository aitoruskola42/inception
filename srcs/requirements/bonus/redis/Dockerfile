FROM alpine:3.20.2

RUN apk update && \
	apk add redis 

CMD ["redis-server", "--protected-mode","no"]
