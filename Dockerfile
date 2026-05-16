FROM alpine:latest
LABEL MAINTAINER="https://github.com/r4tur1/nullphish"
WORKDIR /nullphish/
ADD . /nullphish
RUN apk add --no-cache bash ncurses curl unzip wget php 
CMD "./nullphish.sh"
