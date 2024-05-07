FROM archlinux:base-devel

COPY resources/pacman.conf /etc/pacman.conf
COPY resources/mirrorlist /etc/pacman.d/mirrorlist
COPY resources/makepkg.conf /etc/makepkg.conf
COPY resources/sudoers /etc/sudoers

RUN pacman-db-upgrade && \
    pacman -Syy --noconfirm archlinux-keyring git base-devel && \
    useradd -ms /bin/sh build && \
    mkdir /output && \
    chown build:build /output

USER build
WORKDIR /home/build