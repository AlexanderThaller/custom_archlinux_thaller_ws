FROM archlinux:base-devel

ARG CACHEBUST=1

COPY resources/makepkg.conf /etc/makepkg.conf
COPY resources/mirrorlist /etc/pacman.d/mirrorlist
COPY resources/pacman.conf /etc/pacman.conf
COPY resources/sudoers /etc/sudoers

RUN pacman-db-upgrade && \
    pacman -Syyu --noconfirm archlinux-keyring git base-devel icu && \
    useradd -ms /bin/sh build && \
    mkdir /output && \
    chown build:build /output

USER build
WORKDIR /home/build
