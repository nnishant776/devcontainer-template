FROM golang:latest

RUN apt -y update

RUN apt -y install \
    systemd \
    git \
    tree \
    curl \
    nano \
    python3-pip \
    unzip \
    tar \
    gzip

RUN apt -y clean all

ENV PS1="[\u@\h \W]# "

# Optional. Remove or change to something else based on the requirements
COPY post_create /usr/local/bin/post_create
RUN post_create
